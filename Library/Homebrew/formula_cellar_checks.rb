module FormulaCellarChecks
  def check_PATH bin
    # warn the user if stuff was installed outside of their PATH
    return unless bin.directory?
    return unless bin.children.length > 0

    bin = (HOMEBREW_PREFIX/bin.basename).realpath
    return if ORIGINAL_PATHS.include? bin

    ["#{bin} is not in your PATH",
      "You can amend this by altering your ~/.bashrc file"]
  end

  def check_manpages
    # Check for man pages that aren't in share/man
    return unless (f.prefix+'man').directory?

    ['A top-level "man" directory was found.',
      <<-EOS.undent
        Homebrew requires that man pages live under share.
        This can often be fixed by passing "--mandir=#{man}" to configure.
      EOS
    ]
  end

  def check_infopages
    # Check for info pages that aren't in share/info
    return unless (f.prefix+'info').directory?

    ['A top-level "info" directory was found.',
      <<-EOS.undent
        Homebrew suggests that info pages live under share.
        This can often be fixed by passing "--infodir=#{info}" to configure.
      EOS
    ]
  end

  def check_jars
    return unless f.lib.directory?

    jars = f.lib.children.select{|g| g.to_s =~ /\.jar$/}
    return if jars.empty?

    ['JARs were installed to "lib".',
      <<-EOS.undent
        Installing JARs to "lib" can cause conflicts between packages.
        For Java software, it is typically better for the formula to
        install to "libexec" and then symlink or wrap binaries into "bin".
        "See "activemq", "jruby", etc. for examples."
        "The offending files are:"
        #{jars}
      EOS
    ]
  end

  def check_non_libraries
    return unless f.lib.directory?

    valid_extensions = %w(.a .dylib .framework .jnilib .la .o .so
                          .jar .prl .pm .sh)
    non_libraries = f.lib.children.select do |g|
      next if g.directory?
      not valid_extensions.include? g.extname
    end
    return if non_libraries.empty?

    ['Non-libraries were installed to "lib".',
      <<-EOS.undent
        Installing non-libraries to "lib" is bad practice.
        The offending files are:
        #{non_libraries}
      EOS
    ]
  end

  def check_non_executables bin
    return unless bin.directory?

    non_exes = bin.children.select { |g| g.directory? or not g.executable? }
    return if non_exes.empty?

    ["Non-executables were installed to \"#{bin}\".",
      <<-EOS.undent
        The offending files are:
        #{non_exes}"
      EOS
    ]
  end
end
