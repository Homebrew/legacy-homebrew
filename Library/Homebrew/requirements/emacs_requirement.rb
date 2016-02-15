class EmacsRequirement < Requirement
  fatal true
  default_formula "emacs"

  def initialize(tags)
    @version = tags.shift if /\d+\.*\d*/ === tags.first
    super
  end

  satisfy :build_env => false do
    next false unless which "emacs"
    next true unless @version
    emacs_version = Utils.popen_read("emacs", "--batch", "--eval", "(princ emacs-version)")
    Version.new(emacs_version) >= Version.new(@version)
  end

  env do
    ENV.prepend_path "PATH", which("emacs").dirname
    ENV["EMACS"] = "emacs"
  end

  def message
    if @version
      s = "Emacs #{@version} or later is required."
    else
      s = "Emacs is required."
    end
    s += super
    s
  end

  def inspect
    "#<#{self.class.name}: #{name.inspect} #{tags.inspect} version=#{@version.inspect}>"
  end
end
