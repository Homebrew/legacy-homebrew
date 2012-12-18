require 'formula'

class Libgtest < Formula
  homepage 'http://code.google.com/p/googletest/'
  url 'http://googletest.googlecode.com/files/gtest-1.6.0.zip'
  sha1 '00d6be170eb9fc3b2198ffdcb1f1d6ba7fc6e621'

  # Googletest requires a source-only installation. This script mimics
  # the behaviour of 'apt-get install libgtest-dev' on Debian, which
  # puts the headers into /usr/include/gtest and the source, including
  # cmake build scripts, into /usr/src/gtest.  Since Homebrew does not
  # map /usr/loca/src, the sources are accessible at ...opt/libgtest/.
  def install
    makedirs self.include
    cp_r 'include/gtest', self.include
    cp_r ['CMakeLists.txt', 'cmake', 'src'], self.prefix
    ohai 'Sources installed to '+self.opt_prefix
  end
end
