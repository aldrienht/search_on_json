require 'minitest/autorun'
require 'stringio'
require_relative 'app.rb'

class AppTest < Minitest::Test
  def setup
    @json_data = '[{"full_name": "John Doe", "email": "john@example.com"}, {"full_name": "Mr Dup", "email": "john@example.com"}, {"full_name": "Jane Smith", "email": "jane@example.com"}]'
  end

  def test_search_by_name_with_results
    parsed_data = JSON.parse(@json_data)
    assert_output(/Here are the found records for 'John':/) do
      search_by_name('John', parsed_data)
    end
  end

  def test_search_by_name_with_no_results
    parsed_data = JSON.parse(@json_data)
    assert_output(/No records found for 'NoMan'/) do
      search_by_name('NoMan', parsed_data)
    end
  end

  def test_find_duplicate_emails_with_duplicates
    parsed_data = JSON.parse(@json_data)
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
