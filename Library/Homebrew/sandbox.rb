require "erb"
require "tempfile"

class Sandbox
  SANDBOX_EXEC = "/usr/bin/sandbox-exec".freeze

  def self.available?
    OS.mac? && File.executable?(SANDBOX_EXEC)
  end

  def initialize
    @profile = SandboxProfile.new
  end

  def record_log(file)
    @log = file
  end

  def add_rule(rule)
    @profile.add_rule(rule)
  end

  def allow_write(path, options={})
    add_rule :allow => true, :operation => "file-write*", :filter => path_filter(path, options[:type])
  end

  def deny_write(path, options={})
    add_rule :allow => false, :operation => "file-write*", :filter => path_filter(path, options[:type])
  end

  def allow_write_path(path)
    allow_write path, :type => :subpath
  end

  def deny_write_path(path)
    deny_write path, :type => :subpath
  end

  def allow_write_temp_and_cache
    allow_write_path "/private/tmp"
    allow_write "^/private/var/folders/[^/]+/[^/]+/[C,T]/", :type => :regex
    allow_write_path HOMEBREW_TEMP
    allow_write_path HOMEBREW_CACHE
  end

  def allow_write_cellar(formula)
    allow_write_path formula.rack
    allow_write_path formula.etc
    allow_write_path formula.var
  end

  def allow_write_log(formula)
    allow_write_path formula.logs
  end

  def deny_write_homebrew_library
    deny_write_path HOMEBREW_LIBRARY
    deny_write_path HOMEBREW_REPOSITORY/".git"
    deny_write HOMEBREW_BREW_FILE
  end

  def exec(*args)
    begin
      seatbelt = Tempfile.new(["homebrew", ".sb"], HOMEBREW_TEMP)
      seatbelt.write(@profile.dump)
      seatbelt.close
      @start = Time.now
      safe_system SANDBOX_EXEC, "-f", seatbelt.path, *args
    rescue
      if ARGV.verbose?
        ohai "Sandbox profile:"
        puts @profile.dump
      end
      raise
    ensure
      seatbelt.unlink
      unless @log.nil?
        sleep 0.1 # wait for a bit to let syslog catch up the latest events.
        syslog_args = %W[
          -F '$((Time)(local))\ $(Sender)[$(PID)]:\ $Message'
          -k Time ge #{@start.to_i.to_s}
          -k Sender kernel
          -o
          -k Time ge #{@start.to_i.to_s}
          -k Sender sandboxd
        ]
        quiet_system "syslog #{syslog_args * " "} | grep deny > #{@log}"
      end
    end
  end

  private

  def expand_realpath(path)
    raise unless path.absolute?
    path.exist? ? path.realpath : expand_realpath(path.parent)/path.basename
  end

  def path_filter(path, type)
    case type
    when :regex        then "regex \#\"#{path}\""
    when :subpath      then "subpath \"#{expand_realpath(Pathname.new(path))}\""
    when :literal, nil then "literal \"#{expand_realpath(Pathname.new(path))}\""
    end
  end

  class SandboxProfile
    SEATBELT_ERB = <<-EOS.undent
      (version 1)
      (debug deny) ; log all denied operations to /var/log/system.log
      <%= rules.join("\n") %>
      (allow file-write*
          (literal "/dev/ptmx")
          (literal "/dev/dtracehelper")
          (literal "/dev/null")
          (regex #"^/dev/fd/[0-9]+$")
          (regex #"^/dev/ttys?[0-9]*$")
          )
      (deny file-write*) ; deny non-whitelist file write operations
      (allow default) ; allow everything else
    EOS

    attr_reader :rules

    def initialize
      @rules = []
    end

    def add_rule(rule)
      s = "("
      s << (rule[:allow] ? "allow": "deny")
      s << " #{rule[:operation]}"
      s << " (#{rule[:filter]})" if rule[:filter]
      s << " (with #{rule[:modifier]})" if rule[:modifier]
      s << ")"
      @rules << s
    end

    def dump
      ERB.new(SEATBELT_ERB).result(binding)
    end
  end
end
