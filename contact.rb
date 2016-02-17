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
    new_contact = Contact.connection.exec_params('INSERT INTO contacts (name, email) VALUES ($1, $2)', [self.name, self.email])     
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
      new_contact_instance = connection.exec('SELECT * FROM contacts')
      new_contact_instance.to_a
    end


    def create(name, email)
      new_contact = Contact.new(name, email)
      new_contact.save
      new_contact
    end

    def find(id)
      contact = connection.exec_params('SELECT * FROM contacts WHERE id = $1::int', [id.to_i])
      contact.to_a[0]
    end
    
    def search(term)
      if term
        contact_list = self.all.select do |contact|
          contact.name.include?(term) || contact.email.include?(term)
        end
      end
    end

  end

end