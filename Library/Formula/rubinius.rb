require 'formula'

class Rubinius < Formula
  url 'http://asset.rubini.us/rubinius-1.1.1-20101116.tar.gz'
  version '1.1.1'
  homepage 'http://rubini.us/'
  md5 'b39f618eeba37c3aff215da8bca55fd7'
  head 'git://github.com/evanphx/rubinius.git'

  # Do not strip binaries, or else it fails to run.
  skip_clean :all

  def install
    # Let Rubinius define its own flags; messing with these causes build breaks.
    %w{CC CXX LD CFLAGS CXXFLAGS CPPFLAGS LDFLAGS}.each { |e| ENV.delete(e) }

    system "/usr/bin/ruby", "./configure",
                          "--skip-system", # download and use the prebuilt LLVM
                          "--prefix", prefix,
                          "--includedir", "#{include}/rubinius",
                          "--libdir", lib,
                          "--mandir", man, # For completeness; no manpages exist yet.
                          "--gemsdir", "#{lib}/rubinius/gems"

    ohai "config.rb", File.open('config.rb').to_a if ARGV.debug? or ARGV.verbose?

    system "/usr/bin/ruby", "-S", "rake", "install"
  end

  def caveats; <<-EOS.undent
    Consider using RVM or Cinderella to manage Ruby environments:
      * RVM: http://rvm.beginrescueend.com/
      * Cinderella: http://www.atmos.org/cinderella/
    EOS
  end
end
