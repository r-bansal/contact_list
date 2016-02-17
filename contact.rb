require 'byebug'
require 'csv'
require 'pg'

class Contact

  attr_accessor :id, :name, :email
  
  def initialize(id=nil, name, email)
    @id = id
    @name = name
    @email = email
  end

  def save
    if self.id == nil
      new_contact = Contact.connection.exec_params('INSERT INTO contacts (name, email) VALUES ($1, $2)', [self.name, self.email])     
    else
      update_contact = Contact.connection.exec_params('UPDATE contacts SET name = $1, email = $2 WHERE id = $3::int', [self.name, self.email, self.id])
    end
  end

  def destroy
    delete_contact = Contact.connection.exec_params('DELETE FROM contacts WHERE id = $1::int', [self.id])
  end

  class << self

    def connection
      conn = PG.connect(
        host: 'localhost',
        dbname: 'contact_list',
        user: 'development',
        password: 'development'
        )
    end

    def all
      new_contact_instance = connection.exec('SELECT * FROM contacts ORDER BY id')
      contacts = []
      new_contact_instance.to_a.each do |contact|
        contact = Contact.new(contact['id'].to_i, contact['name'], contact['email'])
        contacts << contact
      end
      contacts
    end


    def create(name, email)
      new_contact = Contact.new(name, email)
      new_contact.save
      new_contact
    end

    def find(id)
      contact = connection.exec_params('SELECT * FROM contacts WHERE id = $1::int', [id.to_i])
      if contact.to_a != []
        new_contact = Contact.new(contact.to_a[0]['id'].to_i, contact.to_a[0]['name'], contact.to_a[0]['email'])
        new_contact
      end
    end
    
    def search(term)
      if term
        contact_list = []
        contacts = connection.exec_params('SELECT * FROM contacts WHERE name LIKE $1
                                            OR email LIKE $1', ["%#{term}%"])
        contacts.to_a.each do |contact|
          contact = Contact.new(contact['id'].to_i, contact['name'], contact['email'])
          contact_list << contact
        end
        contact_list
      end
    end

  end

end