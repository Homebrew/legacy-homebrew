
def analytics_anonymous_prefix_and_os
  @analytics_anonymous_prefix_and_os ||= begin
    "#{OS_VERSION}, #{HOMEBREW_PREFIX.to_s.gsub(ENV["HOME"], "~")}"
  end
end

def report_analytics(type, metadata={})
  return unless ENV["HOMEBREW_ANALYTICS"]

  metadata_args = metadata.map do |key, value|
    ["-d", "#{key}=#{value}"] if key && value
  end.compact.flatten

  # Send analytics. Anonymise the IP address (aip=1) and don't send or store
  # any personally identifiable information.
  # https://developers.google.com/analytics/devguides/collection/protocol/v1/devguide
  # https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters
  system "curl", "https://www.google-analytics.com/collect", "-d", "v=1",
    "--silent", "--max-time", "3", "--output", "/dev/null",
    "--user-agent", "#{HOMEBREW_USER_AGENT}",
    "-d", "tid=#{ENV["HOMEBREW_ANALYTICS_ID"]}",
    "-d", "cid=#{ENV["HOMEBREW_ANALYTICS_USER_UUID"]}",
    "-d", "aip=1",
    "-d", "an=Homebrew",
    "-d", "av=#{HOMEBREW_VERSION}",
    "-d", "t=#{type}",
    *metadata_args
end

def report_analytics_event(category, action, label=analytics_anonymous_prefix_and_os, value=nil)
  report_analytics(:event, {
    :ec => category,
    :ea => action,
    :el => label,
    :ev => value,
  })
end

def report_analytics_exception(exception, options={})
  if exception.is_a? BuildError
    report_analytics_event("BuildError", e.formula.full_name)
  end

  fatal = options.fetch(:fatal, true) ? "1" : "0"
  report_analytics(:exception, {
    :exd => exception.class.name,
    :exf => fatal,
  })
end

def report_analytics_screenview(screen_name)
  report_analytics(:screenview, :cd => screen_name)
end
