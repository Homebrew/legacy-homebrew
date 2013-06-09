class Formulary
  # Return a Formula instance for the given `name`.
  # `name` may be:
  # * a Formula instance, in which case it is returned
  #   TODO: is this code path used?
  # * a Pathname to a local formula
  # * a string containing a formula pathname
  # * a string containing a formula URL
  # * a string containing a formula name
  # * a string containing a local bottle reference
  def self.factory name
    # If an instance of Formula is passed, just return it
    return name if name.kind_of? Formula

    # Otherwise, convert to String in case a Pathname comes in
    name = name.to_s

    # If a URL is passed, download to the cache and install
    if name =~ %r[(https?|ftp)://]
      url = name
      name = Pathname.new(name).basename
      path = HOMEBREW_CACHE_FORMULA+name
      name = name.basename(".rb").to_s

      unless Object.const_defined? Formula.class_s(name)
        HOMEBREW_CACHE_FORMULA.mkpath
        FileUtils.rm path, :force => true
        curl url, '-o', path
      end

      install_type = :from_url
    elsif name.match bottle_regex
      bottle_filename = Pathname(name).realpath
      version = Version.parse(bottle_filename).to_s
      bottle_basename = bottle_filename.basename.to_s
      name_without_version = bottle_basename.rpartition("-#{version}").first
      if name_without_version.empty?
        if ARGV.homebrew_developer?
          opoo "Add a new version regex to version.rb to parse this filename."
        end
      else
        name = name_without_version
      end
      path = Formula.path(name)
      install_type = :from_local_bottle
    else
      name = Formula.canonical_name(name)

      if name =~ %r{^(\w+)/(\w+)/([^/])+$}
        # name appears to be a tapped formula, so we don't munge it
        # in order to provide a useful error message when require fails.
        path = Pathname.new(name)
      elsif name.include? "/"
        # If name was a path or mapped to a cached formula

        # require allows filenames to drop the .rb extension, but everything else
        # in our codebase will require an exact and fullpath.
        name = "#{name}.rb" unless name =~ /\.rb$/

        path = Pathname.new(name)
        name = path.stem
        install_type = :from_path
      else
        # For names, map to the path and then require
        path = Formula.path(name)
        install_type = :from_name
      end
    end

    klass_name = Formula.class_s(name)
    unless Object.const_defined? klass_name
      puts "#{$0}: loading #{path}" if ARGV.debug?
      require path
    end

    begin
      klass = Object.const_get klass_name
    rescue NameError
      # TODO really this text should be encoded into the exception
      # and only shown if the UI deems it correct to show it
      onoe "class \"#{klass_name}\" expected but not found in #{name}.rb"
      puts "Double-check the name of the class in that formula."
      raise LoadError
    end

    if install_type == :from_local_bottle
      formula = klass.new(name)
      formula.downloader.local_bottle_path = bottle_filename
      return formula
    end

    raise NameError if !klass.ancestors.include? Formula
    raise NameError if klass == Formula

    return klass.new(name) if install_type == :from_name
    return klass.new(name, path.to_s)
  rescue NoMethodError
    # This is a programming error in an existing formula, and should not
    # have a "no such formula" message.
    raise
  rescue LoadError, NameError
    # Catch NameError so that things that are invalid symbols still get
    # a useful error message.
    raise FormulaUnavailableError.new(name)
  end
end
