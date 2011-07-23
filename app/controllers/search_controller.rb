class SearchController < ApplicationController

  def search
    $solr.delete_by_query "version_downloads_text:[0 TO 9]"
    $solr.commit
    
    if params[:q]
      @search = Rubygem.search(
        q: params[:q].present? ? params[:q] : '*:*'
      )
    end
    @search ||= {'response' => {}, 'response' => {'docs' => []}}
    @docs  = @search['response']['docs']
    @exact = @docs.find{ |d| d.name == params[:q] }
  end

end
