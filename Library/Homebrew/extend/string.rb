class String
  def undent
    gsub(/^.{#{slice(/^ +/).length}}/, '')
  end

  unless String.method_defined?(:start_with?)
    def start_with? prefix
      prefix = prefix.to_s
      self[0, prefix.length] == prefix
    end
  end
end

# used by the inreplace function (in utils.rb)
module StringInreplaceExtension
  # Looks for Makefile style variable defintions and replaces the
  # value with "new_value", or removes the definition entirely.
  def change_make_var! flag, new_value
    new_value = "#{flag}=#{new_value}"
    gsub! Regexp.new("^#{flag}[ \\t]*=[ \\t]*(.*)$"), new_value
  end

  # Removes variable assignments completely.
  def remove_make_var! flags
    # Next line is for Ruby 1.9.x compatibility
    flags = [flags] unless flags.kind_of? Array
    flags.each do |flag|
      # Also remove trailing \n, if present.
      gsub! Regexp.new("^#{flag}[ \\t]*=(.*)$\n?"), ""
    end
  end

  # Finds the specified variable
  def get_make_var flag
    m = match Regexp.new("^#{flag}[ \\t]*=[ \\t]*(.*)$")
    return m[1] if m
    return nil
  end
end
