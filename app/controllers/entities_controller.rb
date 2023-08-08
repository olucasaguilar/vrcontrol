class EntitiesController < ApplicationController
  def index
    @entities = Entity.all
  end
end
