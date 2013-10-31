FormulaConflict = Struct.new(:name, :reason)

# Used to annotate formulae that duplicate OS X provided software
# or cause conflicts when linked in.
class KegOnlyReason
  attr_reader :reason, :explanation

  def initialize reason, explanation=nil
    @reason = reason
    @explanation = explanation
    @valid = case @reason
      when :provided_pre_mountain_lion then MacOS.version < :mountain_lion
      else true
      end
  end

  def valid?
    @valid
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
    else
      @reason
    end.strip
  end
end
