class PerlRequirement < Requirement
  fatal true
  default_formula "perl"

  def initialize(tags)
    @version = tags.shift if /(\d.\d{1,2})/ === tags.first
    raise "PerlRequirement requires a version!" unless @version
    super
  end

  def perl_version
    @perl_version ||= Utils.popen_read("perl", "--version")[/(\d\.\d(\d)?)/, 1]
  end

  satisfy :build_env => false do
    next unless which "perl"
    next unless perl_version
    Version.new(perl_version) >= Version.new(@version)
  end

  env do
    if Version.new(perl_version) >= Version.new(@version)
      ENV.prepend_path "PATH", which("perl").dirname
    else
      ENV.prepend_path "PATH", Formula["perl"].opt_bin
    end
  end

  def message
    s = "Perl #{@version} is required to install this formula."
    s += super
    s
  end

  def inspect
    "#<#{self.class.name}: #{name.inspect} #{tags.inspect} version=#{@version.inspect}>"
  end
end
