module SignaturesHelper
  def time_diff(start_time, end_time)
    return "xx:xx" if end_time.nil?
    diff = (start_time - end_time).round
    hours = diff.abs / 3600
    dt = DateTime.strptime(diff.abs.to_s, "%s").utc
    hours = -hours if diff < 0
    "#{hours}:#{dt.strftime("%M")}"
  end
end
