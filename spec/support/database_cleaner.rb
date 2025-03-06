# spec/rails_helper.rb or spec/support/database_cleaner.rb
RSpec.configure do |config|
  # Add DatabaseCleaner
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
