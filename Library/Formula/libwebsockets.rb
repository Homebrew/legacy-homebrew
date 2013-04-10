require 'formula'

class Libwebsockets < Formula
  homepage 'http://git.warmcat.com/cgi-bin/cgit/libwebsockets'
  url 'http://git.warmcat.com/cgi-bin/cgit/libwebsockets/snapshot/libwebsockets-1.22-chrome26-firefox18.tar.gz'
  version '1.22'
  sha1 'e1bc750cf206699a7fbafc59db82c33c49948680'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"

    # The `make install` target doesn’t work (FFS) so here’s what I think
    # should be installed:
    lib.install 'lib/libwebsockets.dylib'
    include.install 'lib/libwebsockets.h'
  end
end
