# Used to track formulae that cannot be installed at the same time
FormulaConflict = Struct.new(:name, :reason)

# Used to annotate formulae that duplicate OS X provided software
# or cause conflicts when linked in.
class KegOnlyReason
  attr_reader :reason, :explanation

  def initialize reason, explanation=nil
    @reason = reason
    @explanation = explanation
  end

  def valid?
    case @reason
    when :provided_pre_mountain_lion
      MacOS.version < :mountain_lion
    when :provided_until_xcode43
      MacOS::Xcode.version < "4.3"
    when :provided_until_xcode5
      MacOS::Xcode.version < "5.0"
    else
      true
    end
  end

  def to_s
    case @reason
    when :provided_by_osx then <<-EOS.undent
      Mac OS X already provides this software and installing another version in
      parallel can cause all kinds of trouble.

      #{@explanation}
      EOS
    when :provided_pre_mountain_lion then <<-EOS.undent
      Mac OS X already provides this software in versions before Mountain Lion.

      #{@explanation}
      EOS
    when :provided_until_xcode43
      "Xcode provides this software prior to version 4.3.\n\n#{explanation}"
    when :provided_until_xcode5
      "Xcode provides this software prior to version 5.\n\n#{explanation}"
    else
      @reason
    end.strip
  end
end
