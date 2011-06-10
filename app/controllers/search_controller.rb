class SearchController < ApplicationController

  def search
    if params[:q]
      @search = Rubygem.search(
        q: params[:q]
      )
      @docs  = @search['response']['docs']
      @exact = @docs.find{ |d| d['name'] == params[:q] }
    end
  end

end
