class LogoutController < ApplicationController
    skip_before_action :authorize_request, only: :logout
  # return auth token once user is authenticated
  def logout
    auth_token = request.headers['Authorization']
    if auth_token == nil
     
      auth_token = params["Authorization"]
    end
	#if there is no token then you cant logout
    if auth_token == nil
      return json_response({message: "Invalid token", status_code: '422'})
    end
    is_token_valid = JsonWebToken.decode(auth_token)
  
    result =  JsonWebToken.invalidate(auth_token)
    
    if result != nil
      respose =  json_response({message: "You have succesfully logged out...", status_code: result})
    else
      response =  json_response({message: "Something went wrong...", status_code: '422'})
    end
    
    return response
  end

  
  private

  def auth_params
    params.permit(:Authorization)
  end
end