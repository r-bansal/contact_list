require 'active_record'

class Contact < ActiveRecord::Base

  belongs_to :contact_list

  class << self

    def search(term)
      if term
        Contact.where("name LIKE ? or email LIKE ?", "%#{term}%", "%#{term}%")
      else
        puts "Invalid command"
      end
    end

  end

end