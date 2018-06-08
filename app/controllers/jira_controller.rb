class JiraController < ApplicationController

  def crawling
    @jira = Jira.all
  end
end
