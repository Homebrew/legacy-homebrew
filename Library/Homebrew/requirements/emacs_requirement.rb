class EmacsRequirement < Requirement
  fatal true
  default_formula "emacs"

  def initialize(tags)
    @version = tags.shift if /\d+\.*\d*/ === tags.first
    raise "Specify a version for EmacsRequirement" unless @version
    super
  end

  satisfy :build_env => false do
    next unless which "emacs"
    emacs_version = Utils.popen_read("emacs", "--batch", "--eval", "(princ emacs-version)")
    Version.new(emacs_version) >= Version.new(@version)
  end

  env do
    ENV.prepend_path "PATH", which("emacs").dirname
  end

  def message
    s = "Emacs #{@version} or later is required."
    s += super
    s
  end

  def inspect
    "#<#{self.class.name}: #{name.inspect} #{tags.inspect} version=#{@version.inspect}>"
  end
end
