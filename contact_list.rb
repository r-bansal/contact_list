require './contact.rb'

class ContactList
  
  input = ARGV
  
  case input[0]
  when "list"
    contacts = Contact.all
    contacts.each_with_index do |contact, index|
      puts "#{contact.id}: #{contact.name} (#{contact.email})"
    end
    puts "-----------------"
    puts "#{contacts.length} records total"
  when "new"
    puts "What is the full (First Last) name of the contact you wish to add?"
    name = STDIN.gets.chomp
    puts "What is the e-mail (name@email.com) address of the contact you wish to add?"
    email = STDIN.gets.chomp
    new_contact = Contact.create(name, email)
    puts "#{new_contact.name} (#{new_contact.email}) contact was created successfully!"
  when "show"
    contact = Contact.find(input[1])
    if contact
      puts "#{contact.name}"
      puts "(#{contact.email})"
    else
      puts "Contact Not Found!"
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
  else
    puts "Here is a list of available commands:"
    puts "    new     - Create a new contact"
    puts "    list    - List all contacts"
    puts "    show    - Show a contact"
    puts "    search  - Search contacts"
  end

end