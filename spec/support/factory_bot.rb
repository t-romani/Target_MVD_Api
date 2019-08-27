#Factory Bot configuration
  RSpec.configure do |config|
    include ActionDispatch::TestProcess

    config.include FactoryBot::Syntax::Methods
  end
