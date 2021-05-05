class TopController < ApplicationController

  def index

  end

  def index_bulma
    @editable = params[:editable] == 'true'
    render layout:  'bulma/application'
  end

  def index_bootstrap
    @editable = params[:editable] == 'true'
    render layout: 'bootstrap/application'
  end
end
