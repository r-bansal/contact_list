require 'byebug'
require 'csv'

class Contact

  attr_accessor :id, :name, :email
  
  def initialize(id=nil, name, email)
    @id = id
    @name = name
    @email = email
  end

  class << self

    def all
      contact_list = []
      CSV.open('contact_list.csv').each_with_index do |new_contact, index|
        new_contact_instance = Contact.new(index + 1, new_contact[0], new_contact[1])
        contact_list << new_contact_instance
      end
      contact_list
    end

    def create(name, email)
      new_contact = Contact.new(name, email)
      CSV.open('contact_list.csv', 'a') do |csv|
        csv << [new_contact.name, new_contact.email]
      end
      new_contact
    end
    
    def find(id)
      contact_list = self.all
      contact = nil
      # for .select, you could of passed a block, also .select may return multiple items, using .find will return only one (same #search below)
      contact_list.select do |num| 
        if num.id == id.to_i
          contact = num
        end
      end
      contact
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
