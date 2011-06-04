class SearchController < ApplicationController

  def search
    if params[:q]
      Rubygem.search(
        q: params[:q]
      )
    end
  end

end
