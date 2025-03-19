module Api
  class TestsController < ApplicationController
    def index
      render json: [
        { id: 1, value: "test 1" },
        { id: 2, value: "test 2" },
        { id: 3, value: "test 3" }
      ]
    end
  end
end
