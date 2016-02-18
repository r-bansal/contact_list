require './contact.rb'
require 'active_record'
require 'pry'

class ContactList < ActiveRecord::Base

  has_many :contacts

  def self.initialize_schema
    ActiveRecord::Schema.define do
      create_table :contacts do |t|
        t.column :name, :string
        t.column :email, :string
        t.timestamps null: false
      end
    end
  end
  
  def self.setup

    ActiveRecord::Base.establish_connection(
    adapter: 'postgresql',
    database: 'contact_list',
    username: 'development',
    password: 'development',
    host: 'localhost'
    )

    initialize_schema unless ActiveRecord::Base.connection.table_exists?(:contacts)
    
    input = ARGV
    
    case input[0]
    when "list"
      contacts = Contact.all.order(:id)
      contacts.each do |contact|
        puts "#{contact.id}: #{contact.name} (#{contact.email})"
      end
      puts "-----------------"
      puts "#{contacts.length} records total"
    when "new"
      puts "What is the full (First Last) name of the contact you wish to add?"
      name = STDIN.gets.chomp
      puts "What is the e-mail (name@email.com) address of the contact you wish to add?"
      email = STDIN.gets.chomp
      new_contact = Contact.create(name: name, email: email)
      puts "'#{new_contact.name} (#{new_contact.email})' contact was created successfully!"
    when "show"
      if !input[1]
        puts "Invalid command"
      else
        if Contact.exists?(id: input[1])
          contact = Contact.find(input[1])
          puts "#{contact.name}"
          puts "(#{contact.email})"
        else
          puts "Contact Not Found!"
        end
      end
    when "search"
      contact_list = Contact.search(input[1])
      if contact_list && contact_list.length > 0
        contact_list.each do |contact|
          puts "#{contact.name}"
          puts "(#{contact.email})"
        end
      else
        puts "Contact Not Found!"
      end
    when "update"
      if !input[1]
        puts "Invalid command"
      elsif
        Contact.exists?(id: input[1])
        contact = Contact.find(input[1])
        puts "Which attribute would you like to update ('name' or 'email'):"
        response = STDIN.gets.chomp
        if
          response == 'name'
          puts "What is the new (First and Last) name?"
          new_name = STDIN.gets.chomp
          contact.name = new_name
          contact.save
          puts "Updated name to '#{contact.name}'!"
        elsif
          response == 'email'
          puts "What is the new e-mail address?"
          new_email = STDIN.gets.chomp
          contact.email = new_email
          contact.save
          puts "Updated email to '#{contact.email}'!"
        else
          puts "Invalid command"
        end
      else
        puts "Contact Not Found!"
      end
    when "delete"
      if !input[1]
        puts "Invalid command"
      elsif Contact.exists?(id: input[1])
        contact = Contact.find(input[1])
        contact.destroy
        puts "'#{contact.name} (#{contact.email})' has been deleted!"
      else
        puts "Contact Not Found!"
      end
    else
      puts "Here is a list of available commands:"
      puts "    new     - Create a new contact"
      puts "    list    - List all contacts"
      puts "    show    - Show a contact"
      puts "    search  - Search contacts"
      puts "    update  - Update existing contact"
      puts "    delete  - Delete existing contact"
    end
  end

end

ContactList.setup