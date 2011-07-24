require 'test_helper'

class CheckControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

  def test_ip
    post :ip,
    :ip => '150.65.7.130'
    assert_response :success
  end

  def test_all
    post :all
    assert_response :success
  end

  def test_check20
    post :check20
    assert_response :success
  end

  def test_country
    post :country, :country => 'JPN'
    assert_response :success
  end

  def test_continent
    post :continent, :country => 'AP'
    assert_response :success
  end



end
