require "requirement"

class MaximumMacOSRequirement < Requirement
  fatal true

  def initialize(tags)
    @version = MacOS::Version.from_symbol(tags.first)
    super
  end

  satisfy(:build_env => false) { MacOS.version <= @version }

  def message
    <<-EOS.undent
      This formula either does not compile or function as expected on newer
      OS X versions than #{@version.pretty_name} due to an upstream incompatibility.

      You can try to install the formula with `--HEAD` but one may not be
      defined or the issue may still be present upstream.
    EOS
  end
end
