class LeaderboardsController < ApplicationController
  before_action :query_options
  after_action :allow_iframe, only: :embed

  def embed
  end

  private

    def allow_iframe
      response.headers.except! 'X-Frame-Options'
    end
  end

  def show
    @lb = Boards.default_leaderboard
    @entries = entry_service.execute(query_options)
    respond_to do |format|
      format.html do
        paginate
      end
      format.json do
        render json: @entries
      end
    end
  end

  private

  def paginate
    pager = Kaminari.paginate_array(
      @entries,
      total_count: @lb.total_members)

    @page_array = pager.page(@page).per(@limit)
  end

  def entry_service
    Boards::GetAllService.new
  end
