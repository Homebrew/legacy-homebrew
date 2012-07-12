require 'formula'

class Shiboken < Formula
  homepage 'http://www.pyside.org/docs/shiboken'
  url 'http://pyside.org/files/shiboken-1.1.1.tar.bz2'
  sha1 'd24efc1e7499e9d7db4dfc85a975291e3cb3f311'

  depends_on 'cmake' => :build

  def install
    # Building the tests also runs them. Not building and running tests cuts
    # install time in half.  As of 1.1.1 the install fails unless you do an
    # out of tree build and put the source dir last in the args.
    mkdir 'macbuild' do
      args = std_cmake_args + %W[
        -DBUILD_TESTS=OFF
        ..
      ]
      system 'cmake', *args
      system "make install"
    end
  end
end
