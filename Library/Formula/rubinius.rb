require 'formula'

class Rubinius < Formula
  url 'http://asset.rubini.us/rubinius-1.0.1-20100603.tar.gz'
  version '1.0.1'
  homepage 'http://rubini.us/'
  md5 'eb185703c7ae0c0210e8dcb7f783ee8e'
  head 'git://github.com/evanphx/rubinius.git'

  # Do not strip binaries, or else it fails to run.
  skip_clean :all

  def install
    # Let Rubinius define its own flags; messing with these causes build breaks.
    %w{CC CXX LD CFLAGS CXXFLAGS CPPFLAGS LDFLAGS}.each { |e| ENV.delete(e) }

    ENV['RELEASE'] = version # to fix issues with "path already exists"

    # The configure script uses "#!/usr/bin/env ruby" but complains if you
    # aren't using 1.8, so replace it with the path to the OS X system ruby.
    # (If the user has replaces their system ruby, well, don't do that.)
    inreplace 'configure', "#!/usr/bin/env ruby", "#!/usr/bin/ruby"

    # "--skip-system" means to use the included LLVM
    system "./configure", "--skip-system",
                          "--prefix", prefix,
                          "--includedir", "#{include}/rubinius",
                          "--libdir", lib,
                          "--mandir", man, # For completeness; no manpages exist yet.
                          "--gemsdir", "#{lib}/rubinius/gems"

    ohai "config.rb", File.open('config.rb').to_a if ARGV.debug? or ARGV.verbose?

    system "/usr/bin/ruby", "-S", "rake", "install"
  end

  def caveats; <<-EOS.undent
    Consider using RVM or Cider to manage Ruby environments:
      * RVM: http://rvm.beginrescueend.com/
      * Cider: http://www.atmos.org/cider/intro.html
    EOS
  end
end
