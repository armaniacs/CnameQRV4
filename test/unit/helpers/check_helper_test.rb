require 'test_helper'

class CheckHelperTest < ActionView::TestCase
  def test_check_host
    assert_equal true, check_host('150.65.7.130')[0] #hanzubon.jp
    assert_equal false, check_host('210.157.158.59')[0] #vaio.araki.net
  end
end
