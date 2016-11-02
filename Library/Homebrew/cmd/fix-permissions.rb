require "extend/ENV"

module Homebrew
  def fix_permissions
    fix_permissions_shared(:wait => false)
    system "/usr/bin/sudo", "-k"
  end

  ### !!!!!!!!!!
  ### EVERYTHING between these markers is shared (and should be kept in sync)
  ### with Homebrew/install/install
  ### !!!!!!!!!!
  def sudo *args
    ohai "/usr/bin/sudo #{args.join ' '}"
    system "/usr/bin/sudo", *args
  end

  def fix_permissions_shared(options={})
    wait = options.fetch(:wait, true)

    def chmod?(d)
      File.directory?(d) && !(File.readable?(d) && File.writable?(d) && File.executable?(d))
    end

    def chown?(d)
      File.directory?(d) && !File.owned?(d)
    end

    def chgrp?(d)
      File.directory?(d) && !File.grpowned?(d)
    end

    def getc
      system "/bin/stty raw -echo"
      if STDIN.respond_to?(:getbyte)
        STDIN.getbyte
      else
        STDIN.getc
      end
    ensure
      system "/bin/stty -raw echo"
    end

    def wait_for_user
      puts
      puts "Press RETURN to continue or any other key to abort"
      c = getc
      # we test for \r and \n because some stuff does \r instead
      abort unless c == 13 or c == 10
    end

    paths = %w(
      .
      bin
      etc
      include
      lib
      lib/pkgconfig
      Library
      sbin
      share
      var
      var/log
      share/locale
      share/man
      share/man/man1
      share/man/man2
      share/man/man3
      share/man/man4
      share/man/man5
      share/man/man6
      share/man/man7
      share/man/man8
      share/info
      share/doc
      share/aclocal
    ).map { |d| File.join(HOMEBREW_PREFIX, d) }
    chmods = paths.select { |d| chmod?(d) }
    chowns = paths.select { |d| chown?(d) }
    chgrps = paths.select { |d| chgrp?(d) }

    unless chmods.empty?
      ohai "The following directories will be made group writable:"
      puts(*chmods)
    end
    unless chowns.empty?
      ohai "The following directories will have their owner set to #{Tty.underline 39}#{ENV['USER']}#{Tty.reset}:"
      puts(*chowns)
    end
    unless chgrps.empty?
      ohai "The following directories will have their group set to #{Tty.underline 39}admin#{Tty.reset}:"
      puts(*chgrps)
    end

    wait_for_user if wait && STDIN.tty?

    if File.directory? HOMEBREW_PREFIX
      sudo "/bin/chmod", "g+rwx", *chmods unless chmods.empty?
      sudo "/usr/sbin/chown", ENV['USER'], *chowns unless chowns.empty?
      sudo "/usr/bin/chgrp", "admin", *chgrps unless chgrps.empty?
    else
      sudo "/bin/mkdir", HOMEBREW_PREFIX
      sudo "/bin/chmod", "g+rwx", HOMEBREW_PREFIX
      # the group is set to wheel by default for some reason
      sudo "/usr/sbin/chown", "#{ENV['USER']}:admin", HOMEBREW_PREFIX
    end

    sudo "/bin/mkdir", HOMEBREW_CACHE unless File.directory? HOMEBREW_CACHE
    sudo "/bin/chmod", "g+rwx", HOMEBREW_CACHE if chmod? HOMEBREW_CACHE
    sudo "/usr/sbin/chown", ENV['USER'], HOMEBREW_CACHE if chown? HOMEBREW_CACHE
    sudo "/usr/bin/chgrp", "admin", HOMEBREW_CACHE if chgrp? HOMEBREW_CACHE
  end
  ### !!!!!!!!!!
  ### EVERYTHING between these markers is shared (and should be kept in sync)
  ### with Library/Homebrew/cmd/fix-permissions.rb
  ### !!!!!!!!!!
end
