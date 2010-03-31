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
    puts "You don't have X11 installed as part of your Xcode installation."
    puts "This isn't required for all formula. But it is expected by some."
  end
end

def check_for_other_package_managers
  if macports_or_fink_installed?
    puts "You have Macports or Fink installed. This can cause trouble."
    puts "You don't have to uninstall them, but you may like to try temporarily"
    puts "moving them away, eg."
    puts
    puts "    sudo mv /opt/local ~/macports"
    puts
  end
end

def check_gcc_versions
  gcc_42 = gcc_42_build
  gcc_40 = gcc_40_build

  if gcc_42 < RECOMMENDED_GCC_42
    puts "Your gcc 4.2.x version is older than the recommended version. It may be advisable"
    puts "to upgrade to the latest release of Xcode."
    puts
  end

  if gcc_40 < RECOMMENDED_GCC_40
    puts "Your gcc 4.0.x version is older than the recommended version. It may be advisable"
    puts "to upgrade to the latest release of Xcode."
    puts
  end
end

def check_share_locale
end

def check_usr_bin_ruby
end

def check_homebrew_prefix
end

def brew_doctor
  read, write = IO.pipe

  if fork == nil
    read.close
    $stdout.reopen write
    
    check_for_stray_dylibs
    check_gcc_versions
    check_for_other_package_managers
    check_for_x11

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
