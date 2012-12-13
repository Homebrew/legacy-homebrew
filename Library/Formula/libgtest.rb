require 'formula'

class Libgtest < Formula
  homepage 'http://code.google.com/p/googletest/'
  url 'http://googletest.googlecode.com/files/gtest-1.6.0.zip'
  sha1 '00d6be170eb9fc3b2198ffdcb1f1d6ba7fc6e621'

  depends_on 'cmake' => :build

  def install
    system 'cmake', '.', *std_cmake_args
    system 'make'

    # Gtest's cmake scripts do not generate an "install" target,
    # so we copy the artefacts over manually.
    ohai 'install'
    makedirs [self.lib, self.include]
    cp ['libgtest.a', 'libgtest_main.a'], self.lib
    cp_r 'include/gtest', self.include
  end
end
