# This file is copied to spec/ when you run 'rails generate rspec:install'
#
ENV["RAILS_ENV"] ||= 'test'

if ENV["COVERAGE"] == "true"
  require 'simplecov'
  require 'simplecov-rcov'

  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  SimpleCov.start 'rails' do
    add_filter "/app/helpers/"
  end
end


require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'database_cleaner'
require 'webmock/rspec'
# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  #Randomly order specs run
  config.order = :rand

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  #Give pretty FG methods
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start

    accounts = YAML.load(File.open("#{Rails.root}/config/accounts.yml", "r"))

    stub_request(:get, "https://www.pivotaltracker.com/services/v3/projects/1/activities").
         with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/xml', 'User-Agent'=>'Ruby', 'X-Trackertoken'=>'2756f3896a367902d2555ecbbaf89cc3'}).
         to_return(:status => 200, :body => File.open("#{Rails.root}/spec/support/pt_project_activity.xml"), :headers => {})

    stub_request(:post, "https://www.pivotaltracker.com/services/v3/tokens/active").
       with(:body => {"password"=> accounts["pivotal_tracker"]["password"],
                      "username"=> accounts["pivotal_tracker"]["email"]},
            :headers => {'Accept'=>'*/*; q=0.5, application/xml',
                         'Accept-Encoding'=>'gzip, deflate',
                         'Content-Length'=>'111',
                         'Content-Type'=>'application/x-www-form-urlencoded',
                         'User-Agent'=>'Ruby'}).
       to_return(:status => 200,
                 :body => '<?xml version="1.0" encoding="UTF-8"?>
                          <token>
                            <guid>2756f3896a367902d2555ecbbaf89cc3</guid>
                            <id type="integer">1</id>
                          </token>',
                 :headers => {})

    stub_request(:get, "https://www.pivotaltracker.com/services/v3/activities").
         with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/xml', 'User-Agent'=>'Ruby', 'X-Trackertoken'=>'2756f3896a367902d2555ecbbaf89cc3'}).
         to_return(:status => 200,
                   :body => File.open("#{Rails.root}/spec/support/pt_activity.xml"),
                   :headers => {})

   stub_request(:get, "https://www.pivotaltracker.com/services/v3/projects/1031").
   with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/xml', 'User-Agent'=>'Ruby', 'X-Trackertoken'=>'2756f3896a367902d2555ecbbaf89cc3'}).
         to_return(:status => 200, :body => File.open("#{Rails.root}/spec/support/pt_project.xml"), :headers => {})

  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
