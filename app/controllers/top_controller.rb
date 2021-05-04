class TopController < ApplicationController
  def index
    @editable = params[:editable] == 'true'
    render layout:  'bulma/application'
  end

  def index2
    @editable = params[:editable] == 'true'
    render layout: 'bootstrap/application'
  end
end
