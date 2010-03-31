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

def brew_doctor
  read, write = IO.pipe

  if fork == nil
    read.close
    $stdout.reopen write
    
    check_for_stray_dylibs
    
    if gcc_build < HOMEBREW_RECOMMENDED_GCC
      puts "Your GCC version is older than the recommended version. It may be advisable"
      puts "to upgrade to the latest release of Xcode."
      puts
    end

    if macports_or_fink_installed?
      puts "You have Macports or Fink installed. This can cause trouble."
      puts "You don't have to uninstall them, but you may like to try temporarily"
      puts "moving them away, eg."
      puts
      puts "    sudo mv /opt/local ~/macports"
      puts
    end

    unless File.exists? '/usr/X11/lib/libpng.dylib'
      puts "You don't have X11 installed as part of your Xcode installation."
      puts "This isn't required for all formula. But it is expected by some."
    end

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
