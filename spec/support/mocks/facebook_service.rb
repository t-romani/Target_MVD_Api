class FacebookService
  def initialize(access_token)
    @access_token = access_token
  end

  def profile
    unless @access_token.present? && @access_token != 'invalid'
      raise Koala::Facebook::AuthenticationError.new :bad_request, 'error'
    end

    {
      'first_name' => 'Test',
      'last_name' => 'test',
      'gender' => 'male',
      'email' => 'test@facebook.com',
      'id' => '1234567890',
      'picture' => {
        'data' => {
          'url' => 'spec/support/images/rootstrap.png'
        }
      }
    }
  end
end
