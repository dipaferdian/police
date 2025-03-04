class JwtService
  HMAC_SECRET = Rails.application.credentials.dig(:secret_key_base) || 'IS_SECRET'

  def self.encode(data)
    JWT.encode(data, HMAC_SECRET, 'HS256')
  end

  def self.decode(token)
    JWT.decode(token, HMAC_SECRET, algorithm: 'HS256')
  end 
end