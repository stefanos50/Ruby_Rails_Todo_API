class V2::TodosController < ApplicationController
  def index
    json_response({ message: 'V2 todo controller!'})
  end
end
