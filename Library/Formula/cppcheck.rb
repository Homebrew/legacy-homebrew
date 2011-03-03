require 'formula'

class Cppcheck < Formula
  url 'http://downloads.sourceforge.net/project/cppcheck/cppcheck/1.44/cppcheck-1.44.tar.bz2'
  homepage 'http://sourceforge.net/apps/mediawiki/cppcheck/index.php?title=Main_Page'
  md5 'c8d24c0e7a3db99660f81b8a0568e050'
  head 'git://github.com/danmar/cppcheck.git'

  # Do not strip binaries, or else it fails to run.
  skip_clean :all

  def install
    # Pass to make variables.
    system "make"
    system "make", "DESTDIR=#{prefix}", "BIN=#{bin}", "install"
    # Man pages aren't installed, they require docbook schemas which I don't know how to install.
  end
end
