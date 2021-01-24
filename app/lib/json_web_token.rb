class JsonWebToken
# secret to encode and decode token
  HMAC_SECRET = Rails.application.secrets.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    
    # set expiry to 24 hours from creation time
    if payload[:user_id] != nil
    random_string_database_record = RandomString.where(user_id: payload[:user_id]).take
    payload[:exp] = exp.to_i
	#if record in sqlite database not found for the user_id
    if random_string_database_record == nil
	  #generate random string
	  o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
      random_string = (0...50).map { o[rand(o.length)] }.join
      token = JWT.encode(payload, random_string)
      random_string_database_record = RandomString.create!(user_id: payload[:user_id], random_str:  random_string, user_token: token)
      random_string_database_record.user_token
    else
	  #generate random string
	  o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
      random_string_database_record.random_str =  random_string = (0...50).map { o[rand(o.length)] }.join
      token = JWT.encode(payload, random_string_database_record.random_str)
      random_string_database_record.user_token = token
      random_string_database_record.save
      token
    end
  else
    payload[:exp] = exp.to_i
    # sign token with application secret
    JWT.encode(payload, HMAC_SECRET)
  end
    # sign token with application secret
    
  end

  def self.decode(token)
    
    random_string_database_record = RandomString.where(user_token: token).take
	#if record in sqlite database not found for the given token
    if random_string_database_record == nil
      raise ExceptionHandler::InvalidToken, "Not enough or too many segments"
    else
    
    # get payload; first index in decoded Array
    body = JWT.decode(token, random_string_database_record.random_str)[0]
    HashWithIndifferentAccess.new body
    end
    # rescue from all decode errors
  rescue JWT::DecodeError => e
    # raise custom error to be handled by custom handler
    raise ExceptionHandler::InvalidToken, e.message
  end


  def self.invalidate(token)
    #sometimes def recieves the token as hash ({:token=>'cgfsdf...'}) and sometimes as a string
	#so we have to check each case.
	if Hash === token
		random_string_database_record = RandomString.where(user_token: token[:token]).take
	else
		random_string_database_record = RandomString.where(user_token: token).take
	end
    #p random_string_database_record
    if random_string_database_record == nil
      return nil
    else
	  #generate random string
	  o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
      random_string_database_record.random_str =  (0...50).map { o[rand(o.length)] }.join
      random_string_database_record.save
      return 200
    end
  end
end