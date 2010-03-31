def check_for_stray_dylibs
  bad_dylibs = Dir['/usr/local/lib/*.dylib'].select { |f| File.file? f and not File.symlink? f }
  if bad_dylibs.count > 0
    puts "You have unbrewed dylibs in /usr/local/lib. These could cause build problems"
    puts "when building Homebrew formula. If you no longer need them, delete them:"
    puts
    puts *bad_dylibs.collect { |f| "    #{f}" }
    puts
  end
end

def check_for_x11
  unless File.exists? '/usr/X11/lib/libpng.dylib'
    puts <<-EOS.undent
      You don't have X11 installed as part of your Xcode installation.
      This isn't required for all formula. But it is expected by some.

    EOS
  end
end

def check_for_other_package_managers
  if macports_or_fink_installed?
    puts <<-EOS.undent
      You have Macports or Fink installed. This can cause trouble.
      You don't have to uninstall them, but you may like to try temporarily
      moving them away, eg.

        sudo mv /opt/local ~/macports

    EOS
  end
end

def check_gcc_versions
  gcc_42 = gcc_42_build
  gcc_40 = gcc_40_build

  if gcc_42 < RECOMMENDED_GCC_42
    puts <<-EOS.undent
      Your gcc 4.2.x version is older than the recommended version. It may be advisable
      to upgrade to the latest release of Xcode.

    EOS
  end

  if gcc_40 < RECOMMENDED_GCC_40
    puts <<-EOS.undent
      Your gcc 4.0.x version is older than the recommended version. It may be advisable
      to upgrade to the latest release of Xcode.

    EOS
  end
end

def check_share_locale
  # If PREFIX/share/locale already exists, "sudo make install" of
  # non-brew installed software may cause installation failures.
  locale = HOMEBREW_PREFIX+'share/locale'
  return unless locale.exist?

  cant_read = []

  locale.find do |d|
    next unless d.directory?
    cant_read << d unless d.writable?
  end

  cant_read.sort!
  if cant_read.count > 0
    puts <<-EOS.undent
    Some folders in #{locale} aren't writable.
    This can happen if you "sudo make install" software that isn't managed
    by Homebrew. If a brew tries to add locale information to one of these
    folders, then the install will fail during the link step.
    You should probably `chown` them:

    EOS
    puts *cant_read.collect { |f| "    #{f}" }
    puts
  end

end

def check_usr_bin_ruby
  if /^1\.9/.match RUBY_VERSION
    puts <<-EOS.undent
      Ruby version #{RUBY_VERSION} is unsupported.
      Homebrew is developed and tested on Ruby 1.8.x, and may not work correctly
      on Ruby 1.9.x. Patches are accepted as long as they don't break on 1.8.x.

    EOS
  end
end

def check_homebrew_prefix
  unless HOMEBREW_PREFIX.to_s == '/usr/local'
    puts <<-EOS.undent
      You can install Homebrew anywhere you want, but some brews may not work
      correctly if you're not installing to /usr/local.

    EOS
  end
end

def brew_doctor
  read, write = IO.pipe

  if fork == nil
    read.close
    $stdout.reopen write
    
    check_usr_bin_ruby
    check_homebrew_prefix
    check_for_stray_dylibs
    check_gcc_versions
    check_for_other_package_managers
    check_for_x11
    check_share_locale

    exit! 0
  else
    write.close

    unless (out = read.read).chomp.empty?
      puts out
    else
      puts "Your OS X is ripe for brewing. Any troubles you may be experiencing are"
      puts "likely purely psychosomatic."
    end
  end
end
