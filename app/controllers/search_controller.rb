class SearchController < ApplicationController

  def search
    if params[:q]
      @search = Rubygem.search(
        q: params[:q]
      )
    end
    @search ||= {'response' => {}, 'response' => {'docs' => []}}
    @docs  = @search['response']['docs']
    @exact = @docs.find{ |d| d['name'] == params[:q] }
  end

end
