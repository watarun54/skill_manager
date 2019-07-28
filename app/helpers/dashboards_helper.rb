module DashboardsHelper
  def random_charkick_id
    return 'chart-#'+(Random.rand(10000)).to_s
  end
end
