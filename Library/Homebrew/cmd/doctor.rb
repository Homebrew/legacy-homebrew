require "diagnostic"
require "thread"

module Homebrew
  def doctor
    checks = Diagnostic::Checks.new

    if ARGV.include? "--list-checks"
      puts checks.all.sort
      exit
    end

    checks.inject_dump_stats! if ARGV.switch? "D"

    methods = Queue.new
    reports = Queue.new

    if ARGV.named.empty?
      checks.all.each do |method|
        methods << method
      end
    else
      ARGV.named.each do |method|
        methods << method
      end
    end

    reporter = Thread.new do
      first_warning = true
      while report = reports.deq # wait for nil to break loop
        if first_warning
          $stderr.puts <<-EOS.undent
            #{Tty.white}Please note that these warnings are just used to help the Homebrew maintainers
            with debugging if you file an issue. If everything you use Homebrew for is
            working fine: please don't worry and just ignore them. Thanks!#{Tty.reset}
          EOS
        end

        $stderr.puts
        opoo report
        Homebrew.failed = true
        first_warning = false
      end
    end

    workers = (0...Hardware::CPU.cores).map do
      Thread.new do
        begin
          while method = methods.deq(true)
            if checks.respond_to?(method)
              report = checks.send(method)
              reports << report unless report.nil? || report.empty?
            else
              reports << "No check available by the name: #{method}"
            end
          end
        rescue ThreadError # ignore empty queue error
        end
      end
    end

    workers.map(&:join)
    reports << nil
    reporter.join

    puts "Your system is ready to brew." unless Homebrew.failed?
  end
end
