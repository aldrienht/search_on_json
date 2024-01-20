require 'json'

# Function Definitions

def get_user_input(prompt)
  print prompt
  gets&.chomp.to_s.strip
end

def search_by_name(name, parsed_data)
  begin
    # Regexp.escape(name) = escaping any characters that would have special meaning in a regular expression.
    # i = for case-insensitive
    results = parsed_data.select { |entry| entry['full_name'].match(/#{Regexp.escape(name)}/i) }

    if results.any?
      puts "Here are the found records for '#{name}':"
      results.each { |result| puts result }
    else
      puts "No records found for '#{name}'."
    end
  rescue => e
    puts "An error occurred: #{e.message}"
  end
end

def find_duplicate_emails(parsed_data)
  email_counts = Hash.new(0)

  parsed_data.each do |entry|
    email_counts[entry['email']] += 1
  end

  duplicates = email_counts.select { |email, count| count > 1 }

  if duplicates.any?
    puts "Here are the found duplicate emails:"
    duplicates.each { |email, count| puts "#{email}: #{count} occurrences" }
  else
    puts "No duplicate emails found."
  end
end

def search_again?
  print "Press 'y' to start new transaction or any key to quit. "
  answer = get_user_input('').downcase
  answer == 'y'
end

def load_new_json_file
  loop do
    file_path = get_user_input("Enter the path of the JSON file: ")

    # File.file?(file_path) checks if the path corresponds to a file, not a directory
    if File.exist?(file_path) && File.file?(file_path)
      begin
        json_data = File.read(file_path)
        parsed_json = JSON.parse(json_data)
        puts "JSON data was loaded successfully!"
        return parsed_json
      rescue => e
        puts "Error parsing JSON file: #{e.message}"
      end
    else
      puts "Error: JSON file not found."
    end

    if ENV['APP_ENV'] != 'test'
      print "Do you want to try again? Press 'y' if YES or any key to quit. "
      answer = get_user_input('').downcase
    end

    break unless answer == 'y'
  end

  puts "Exiting. Thank you for using the program!" unless ENV['APP_ENV'] == 'test'
  exit
end

# To prevent executing the main app when running tests
return unless __FILE__ == $0

# Load JSON data
parsed_data = []
current_directory = File.dirname(__FILE__)
json_file_path = File.join(current_directory, 'clients.json')

if File.exist?(json_file_path)
  json_data = File.read(json_file_path)
  parsed_data = JSON.parse(json_data)
else
  puts "Error: JSON file not found."
end


#  Main Program
loop do
  puts "Choose an option:"
  puts "1. Search records by name"
  puts "2. Find duplicate emails"
  puts "3. Load new JSON file"
  choice = get_user_input("Enter your choice (1, 2, or 3): ").downcase

  case choice
  when '1', '3'
    parsed_data = load_new_json_file if choice == '3'
    user_input = get_user_input("Enter name to search in JSON file: ")
    if user_input.empty?
      puts "Error: Please enter a valid name."
      next
    end
    search_by_name(user_input, parsed_data)
  when '2'
    find_duplicate_emails(parsed_data)
  else
    puts "Invalid choice. Please enter 1, 2, or 3."
  end

  unless search_again?
    puts "Exiting. Thank you for using the program!"
    break
  end
end
