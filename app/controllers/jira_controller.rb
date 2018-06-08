class JiraController < ApplicationController

  LIST_PER_PAGE = 50

  def crawling
    if params[:page].blank?
      page = 1
    else
      page = params[:page]
    end

    if params[:search].blank? && params['start_date'].blank? && params['end_date'].blank?
      @jira = Jira.all.order('num desc').page(page).per(LIST_PER_PAGE)
      @jira_group = Jira.all.group('assignee').count
      @jira_date = Jira.all.group('created').count
      @jira_month = Jira.all.group('concat(substring(created,6,2),"월")').count
    elsif params['start_date'].blank? && params['end_date'].blank?
      if params[:search_category].present?
        case params[:search_category]
          when Jira::SEARCH_CATEGORY['REQTS_num'].to_s
            where_clause = "num like '%#{params[:search]}%'"
            @jira = Jira.where(where_clause).order('num DESC').page(page).per(LIST_PER_PAGE)
            @jira_group = Jira.where(where_clause).group('assignee').count
            @jira_date = Jira.where(where_clause).group('created').count
            @jira_month = Jira.where(where_clause).group('concat(substring(created,6,2),"월")').count
          when Jira::SEARCH_CATEGORY['title'].to_s
            where_clause = "title like '%#{params[:search]}%'"
            @jira = Jira.where(where_clause).order('num DESC').page(page).per(LIST_PER_PAGE)
            @jira_group = Jira.where(where_clause).group('assignee').count
            @jira_date = Jira.where(where_clause).group('created').count
            @jira_month = Jira.where(where_clause).group('concat(substring(created,6,2),"월")').count
          when Jira::SEARCH_CATEGORY['assignee'].to_s
            where_clause = "assignee like '%#{params[:search]}%'"
            @jira = Jira.where(where_clause).order('num DESC').page(page).per(LIST_PER_PAGE)
            @jira_group = Jira.where(where_clause).group('assignee').count
            @jira_date = Jira.where(where_clause).group('created').count
            @jira_month = Jira.where(where_clause).group('concat(substring(created,6,2),"월")').count
          when Jira::SEARCH_CATEGORY['reporter'].to_s
            where_clause = "reporter like '%#{params[:search]}%'"
            @jira = Jira.where(where_clause).order('num DESC').page(page).per(LIST_PER_PAGE)
            @jira_group = Jira.where(where_clause).group('assignee').count
            @jira_date = Jira.where(where_clause).group('created').count
            @jira_month = Jira.where(where_clause).group('concat(substring(created,6,2),"월")').count
        end
        @selected_category = params[:search_category].to_s
      end
    else
      if params['start_date'].present? && params['end_date'].present?
        start_date = Jira.change_string_to_time(params['start_date'])
        end_date = Jira.change_string_to_time(params['end_date'])
        @jira = Jira.where("created >= '#{start_date}' and created <= '#{end_date}'")
                    .order('num desc').page(page).per(LIST_PER_PAGE)
        @jira_group = Jira.where("created >= '#{start_date}' and created <= '#{end_date}'")
                          .group('assignee').count
        @jira_date = Jira.where("created >= '#{start_date}' and created <= '#{end_date}'")
                         .group('created').count
        @jira_month = Jira.where("created >= '#{start_date}' and created <= '#{end_date}'")
                          .group('concat(substring(created,6,2),"월")').count
      end
    end

    respond_to do |format|
      format.html
    end
  end
end
