# This is a sample of minimalist command-line application using Ruby

# How to run the app

  1. Open Terminal application
  2. Navigate to app directory e.g. `cd your-project-directory/search_on_json`
  3. Run: `ruby app.rb`
  4. That's it, follow the instructions/promts on your terminal. Enjoy using the app!


# How to run the test

1. Make sure you have installed "minitest" on your system by running the command:
    ```
    gem install minitest
    ```
   Note: You might also need to update the system (e.g., `gem update --system 3.5.5`), ONLY if prompted.

2. Run the test with the following command:
    ```
    APP_ENV=test ruby -Itest /your-absolute-path-here/app_test.rb
    ```
   Replace `/your-absolute-path-here/` with the absolute path to your app directory.

   If already inside the app directory, simply run `APP_ENV=test ruby app_test.rb`


