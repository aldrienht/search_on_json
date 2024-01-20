require 'minitest/autorun'
require 'stringio'
require_relative 'app.rb'

class AppTest < Minitest::Test
  def setup
    @json_data = '[{"full_name": "John Doe", "email": "john@example.com"}, {"full_name": "Mr Dup", "email": "john@example.com"}, {"full_name": "Jane Smith", "email": "jane@example.com"}]'
  end

  def parsed_data
    JSON.parse(@json_data)
  end

  def test_search_by_field_with_results
    assert_output(/Here are the found records for 'John' in the 'full_name' field:/) do
      search_by_field('John', 'full_name', parsed_data)
    end
  end

  def test_search_by_field_with_no_results
    assert_output(/No records found for 'Alex' in the 'email' field./) do
      search_by_field('Alex', 'email', parsed_data)
    end
  end

  def test_search_by_field_with_invalid_data
    assert_output(/An error occurred: undefined method 'to_s' for nil:NilClass/) do
      search_by_field('John', 'invalid_field', parsed_data)
    end
  end

  def test_find_duplicate_emails_with_duplicates
    assert_output(/Here are the found duplicate emails:/) do
      find_duplicate_emails(parsed_data)
    end
  end

  def test_find_duplicate_emails_with_no_duplicates
    parsed_data = JSON.parse('[{"full_name": "John Doe", "email": "john@example.com"}]')
    assert_output(/No duplicate emails found./) do
      find_duplicate_emails(parsed_data)
    end
  end

  def test_load_new_json_file_success_output
    file_path = '/clients.json'

    # Use StringIO to simulate user input
    input = StringIO.new("#{file_path}\n")
    $stdin = input

    result = load_new_json_file

    assert_output(/JSON data was loaded successfully!/) do
      refute_nil(result, "Expected result not to be nil")
      assert_instance_of(Array, result, "Expected result to be an instance of Array")
    end
  ensure
    $stdin = STDIN  # Reset $stdin to its original value
  end

  def test_load_new_json_file_failure
    file_path = '/no-file.json'

    # Use StringIO to simulate user input
    input = StringIO.new("#{file_path}\n")
    $stdin = input

    assert_output(/Error: JSON file not found\./) do
      assert_nil(load_new_json_file)
    end
  ensure
    $stdin = STDIN  # Reset $stdin to its original value
  end
end
