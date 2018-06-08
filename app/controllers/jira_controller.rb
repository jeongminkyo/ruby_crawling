class JiraController < ApplicationController

  LIST_PER_PAGE = 50

  def crawling
    if params[:page].blank?
      page = 1
    else
      page = params[:page]
    end

    @jira = Jira.all.order('num desc').page(page).per(LIST_PER_PAGE)
  end
end
