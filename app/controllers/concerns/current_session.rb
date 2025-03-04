# frozen_string_literal: true

module CurrentSession
  extend ActiveSupport::Concern

  def current_admin
    validate_token && load_current_admin
  end

  private

  def load_current_admin
    User.find_by(email: @data[0]['email'], is_admin: true)
  end

  def validate_token
  begin
    token = request.headers['Authorization'].to_s
    @data = JwtService.decode(token.split(' ').last)
  end  
  rescue StandardError
    nil
  end 
end
