require 'formula'

class Cppcheck < Formula
  url 'http://github.com/danmar/cppcheck/tarball/1.42'
  homepage 'http://sourceforge.net/apps/mediawiki/cppcheck/index.php?title=Main_Page'
  md5 'de8ffbd9d02c4ec01047ef7fd9f208cd'
  head 'git://github.com/danmar/cppcheck.git'

  def install
    # Need to remove "-Wlogical-op" from c++ flags.
    cxxflags = "-Wall -Wextra -pedantic -Wfloat-equal -Wcast-qual -O2 -DNDEBUG"

    # Pass to make variables.
    system "make", "BIN=#{bin}", "CXXFLAGS=#{cxxflags}", "install"
    # Man pages aren't installed, they require docbook schemas which I don't know how to install.
  end
end
