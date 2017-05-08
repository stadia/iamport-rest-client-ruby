require 'test_helper'

class IamportReadyTest < Minitest::Test # :nodoc:
  def setup
    Iamport.configure do |config|
      config.api_key = 'API_KEY'
      config.api_secret = 'API_SECRET'
    end
    @stubs = Faraday::Adapter::Test::Stubs.new
    conn = Faraday.new(url: IAMPORT_HOST) do |builder|
      builder.adapter :test, @stubs do |stub|
      end
    end
    Iamport.stubs(:token).returns('NEW_TOKEN')
  end

  def test_has_a_version_number
    refute_nil Iamport::VERSION
  end

  def test_sets_configuration
    Iamport.configure do |config|
      config.api_key = 'API_KEY'
      config.api_secret = 'API_SECRET'
    end
    assert_equal 'API_KEY', Iamport.config.api_key
    assert_equal 'API_SECRET', Iamport.config.api_secret
  end

  def test_generates_and_returns_new_token
    expected_url = '/users/getToken'
    expected_params = {
      imp_key: 'API_KEY',
      imp_secret: 'API_SECRET'
    }

    response = {
      'response' => {
        'access_token' => 'NEW_TOKEN'
      }
    }

    @stubs.post(expected_url, expected_params) { |_env| [200, {}, response] }
    assert_equal 'NEW_TOKEN', Iamport.token
  end
end
