require 'brewkit'

# Nethack the way God intended it to be played: from a terminal.
# This build script was created referencing:
# * http://nethack.wikia.com/wiki/Compiling#On_Mac_OS_X
# * http://nethack.wikia.com/wiki/Pkgsrc#patch-ac_.28system.h.29
# and copious hacking until things compiled.
#
# The patch applied incorporates the patch-ac above, the OS X
# instructions from the Wiki, and whatever else needed to be
# done.

class Nethack <Formula
  @url='http://downloads.sourceforge.net/project/nethack/nethack/3.4.3/nethack-343-src.tgz'
  @homepage='http://www.nethack.org/index.html'
  @version='3.4.3'
  @md5='21479c95990eefe7650df582426457f9'

  def patches
    {
      :p1 =>
["http://github.com/adamv/nethack-osx/raw/82992eb6e4d8c76b05037579126293d644ef971d/patches/nethack-osx-343.patch"]
    }
  end

  def skip_clean? path
    path == libexec + "nethack/save"
  end

  def install
    # Build everything in-order; no multi builds.
    ENV.deparallelize

    # Symlink makefiles
    system 'sh sys/unix/setup.sh'
    
    ## We are not using the default installer
    # Install to a sane location, geez.
    nethackdir = "#{prefix}/libexec/nethack"
    system "mkdir -p #{nethackdir}"
    
    inreplace "include/config.h",
      '#  define HACKDIR "/usr/games/lib/nethackdir"',
      "#define HACKDIR \"#{nethackdir}\""
    
    # Make the data first, before we munge the CFLAGS
    system "cd dat;make"
    
    Dir.chdir 'dat' do
      nethack_libexec = (libexec+'nethack')
      
      %w(perm logfile).each do |f|
        system "touch #{f}"
        nethack_libexec.install f
      end
      
      # Stage the data
      nethack_libexec.install %w(help hh cmdhelp history opthelp wizhelp dungeon license data oracles options rumors quest.dat)
      nethack_libexec.install Dir['*.lev']
    end
    
    # Make the game
    ENV['CFLAGS'] = ENV['CFLAGS'] + " -I../include"
    system 'cd src;make'
    
    bin.install 'src/nethack'
    system "mkdir #{prefix}/libexec/nethack/save"
  end
end
