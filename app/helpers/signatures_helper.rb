module SignaturesHelper
  def time_diff(start_time, end_time)
    diff = (start_time - end_time).round.abs
    hours = diff / 3600
    dt = DateTime.strptime(diff.to_s, "%s").utc
    "#{hours}:#{dt.strftime("%M")}"
  end
end
