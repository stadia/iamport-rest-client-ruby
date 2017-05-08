require 'test_helper'

class IamportTest < Minitest::Test # :nodoc:
  def setup
    @stubs = Faraday::Adapter::Test::Stubs.new
    conn = Faraday.new(url: IAMPORT_HOST) do |builder|
      builder.adapter :test, @stubs do |stub|
      end
    end
    @payment_json = {
      'amount' => 10_000,
      'apply_num' => '00000000',
      'buyer_addr' => '서울 송파구 잠실동',
      'buyer_email' => 'test@email.com',
      'buyer_name' => '홍길동',
      'buyer_postcode' => nil,
      'buyer_tel' => '01000000001',
      'cancel_amount' => '0',
      'cancel_reason' => nil,
      'cancelled_at' => 0,
      'card_name' => '하나SK 카드',
      'card_quota' => 0,
      'custom_data' => nil,
      'fail_reason' => nil,
      'failed_at' => 0,
      'imp_uid' => 'IMP_UID',
      'merchant_uid' => 'M00001',
      'name' => '제품이름',
      'paid_at' => 1_446_691_529,
      'pay_method' => 'card',
      'pg_provider' => 'nice',
      'pg_tid' => 'w00000000000000000000000000001',
      'receipt_url' => 'RECEIPT_URL',
      'status' => 'paid',
      'user_agent' => 'Mozilla/5.0 (iPhone; CPU iPhone OS 9_0_2 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13A452 Safari/601.1',
      'vbank_date' => 0,
      'vbank_holder' => nil,
      'vbank_name' => nil,
      'vbank_num' => nil
    }
    Iamport.stubs(:conn).returns(conn)
    Iamport.stubs(:token).returns('NEW_TOKEN')
  end

  def test_returns_payment_info
    expected_url = '/payments/IMP_UID'
    expected_headers = {
      'Authorization' => 'NEW_TOKEN'
    }
    response = {
      'code' => 0,
      'response' => @payment_json
    }
    @stubs.get(expected_url, expected_headers) { |_env| [200, {}, response] }

    res = Iamport.payment('IMP_UID')
    assert_equal 'IMP_UID', res['response']['imp_uid']
  end

  def test_returns_payment_list
    expected_url = '/payments/status/all?page=1'
    expected_headers = {
      'Authorization' => 'NEW_TOKEN'
    }
    response = {
      'response' => {
        'total' => 150,
        'previous' => false,
        'next' => 2,
        'list' => [
          @payment_json,
          @payment_json
        ]
      }
    }

    @stubs.get(expected_url, expected_headers) { |_env| [200, {}, response] }

    res = Iamport.payments
    assert_equal 150, res['response']['total']
    assert_equal 2, res['response']['list'].size
  end

  def test_return_cancel_info
    expected_url = '/payments/cancel'
    expected_headers = {
      'Authorization' => 'NEW_TOKEN'
    }
    expected_params = {
      imp_uid: 'IMP_UID',
      merchant_uid: 'M00001'
    }
    response = {
      'code' => 0,
      'message' => '',
      'response' => {
        'imp_uid' => 'IMP_UID',
        'merchant_uid' => 'M00001'
      }
    }
    @stubs.post(expected_url, expected_params) { |_env| [200, {}, response] }

    res = Iamport.cancel(expected_params)
    assert_equal 'IMP_UID', res['response']['imp_uid']
    assert_equal 'M00001', res['response']['merchant_uid']
  end

  def test_return_pyments_using_merchant_uid
    expected_url = '/payments/find/M00001'
    expected_headers = {
      'Authorization' => 'NEW_TOKEN'
    }
    response = {
      'response' => @payment_json
    }
    @stubs.get(expected_url, expected_headers) { |_env| [200, {}, response] }

    res = Iamport.find('M00001')
    assert_equal 'IMP_UID', res['response']['imp_uid']
    assert_equal 'M00001', res['response']['merchant_uid']
  end
end
