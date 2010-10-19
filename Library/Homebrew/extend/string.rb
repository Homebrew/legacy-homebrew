#
# extend/string.rb - extra methods for String
#

class String
  #
  # Unindent entire string by the amount of spaces found at the start of the
  # first line.
  #
  def undent
    gsub /^.{#{slice(/^ +/).length}}/, ''
  end
end
