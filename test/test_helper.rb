ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
# L3.44: red や green を表示できるようにする
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # L5.35 test環境でもfull_titleヘルパーを使用可能に
  include ApplicationHelper

  # Add more helper methods to be used by all tests here...
end
