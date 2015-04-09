require "erb"
require "tempfile"

class Sandbox
  SANDBOX_EXEC = "/usr/bin/sandbox-exec".freeze

  def self.available?
    OS.mac? && File.executable?(SANDBOX_EXEC)
  end

  def initialize(formula=nil)
    @profile = SandboxProfile.new
    unless formula.nil?
      allow_write "/private/tmp", :type => :subpath
      allow_write "/private/var/folders", :type => :subpath
      allow_write HOMEBREW_TEMP, :type => :subpath
      allow_write HOMEBREW_LOGS/formula.name, :type => :subpath
      allow_write HOMEBREW_CACHE, :type => :subpath
      allow_write formula.rack, :type => :subpath
      allow_write formula.etc, :type => :subpath
      allow_write formula.var, :type => :subpath
    end
  end

  def allow_write(path, options={})
    case options[:type]
    when :regex        then filter = "regex \#\"#{path}\""
    when :subpath      then filter = "subpath \"#{expand_realpath(Pathname.new(path))}\""
    when :literal, nil then filter = "literal \"#{expand_realpath(Pathname.new(path))}\""
    end
    @profile.add_rule :allow => true,
                      :operation => "file-write*",
                      :filter => filter
  end

  def exec(*args)
    begin
      seatbelt = Tempfile.new(["homebrew", ".sb"], HOMEBREW_TEMP)
      seatbelt.write(@profile.dump)
      seatbelt.close
      safe_system SANDBOX_EXEC, "-f", seatbelt.path, *args
    rescue
      if ARGV.verbose?
        ohai "Sandbox profile:"
        puts @profile.dump
      end
      raise
    ensure
      seatbelt.unlink
    end
  end

  private

  def expand_realpath(path)
    raise unless path.absolute?
    path.exist? ? path.realpath : expand_realpath(path.parent)/path.basename
  end

  class SandboxProfile
    SEATBELT_ERB = <<-EOS.undent
      (version 1)
      (debug deny) ; log all denied operations to /var/log/system.log
      <%= rules.join("\n") %>
      (allow file-write*
          (literal "/dev/dtracehelper")
          (literal "/dev/null")
          (regex #"^/dev/fd/\\d+$")
          (regex #"^/dev/tty\\d*$")
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
