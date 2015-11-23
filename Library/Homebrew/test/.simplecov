# vim: filetype=ruby

SimpleCov.start do
  tests_path = File.dirname(__FILE__)

  minimum_coverage 50
  coverage_dir File.expand_path("#{tests_path}/coverage")
  root File.expand_path("#{tests_path}/../../")

  add_filter "vendor/bundle/"
  add_filter "Formula/"
  add_filter "Homebrew/compat/"
  add_filter "Homebrew/test/"
  add_filter "Homebrew/vendor/"
end

if name = ENV["HOMEBREW_INTEGRATION_TEST"]
  SimpleCov.command_name "brew #{name}"
  SimpleCov.at_exit do
    exit_code = $!.nil? ? 0 : $!.status
    $stdout.reopen("/dev/null")
    SimpleCov.result.format!
    exit! exit_code
  end
end
