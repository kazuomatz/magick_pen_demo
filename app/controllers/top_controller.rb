class TopController < ApplicationController
  def index
    @editable = params[:editable] == 'true'
  end

  def index2
    render layout: 'application-vue'
  end
end
