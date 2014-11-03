require 'formula'

class Libwebsockets < Formula
  homepage 'http://libwebsockets.org'
  url 'http://git.libwebsockets.org/cgi-bin/cgit/libwebsockets/snapshot/libwebsockets-1.23-chrome32-firefox24.tar.gz'
  version '1.23'
  sha1 '9dda683a342b16feb1cef183f89f9ed4474626f5'
  head 'git://git.libwebsockets.org/libwebsockets'

  bottle do
    cellar :any
    revision 1
    sha1 "11aaee95632443e8271d5633374f37de7b6ee7fa" => :yosemite
    sha1 "fc2c6e8f445504876c4bc6bb6dda437794a646c7" => :mavericks
    sha1 "2205679e9019c6d853b7455809baf9c7a963bed4" => :mountain_lion
  end

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"

    # The `make install` target doesn't work so here's what I think
    # should be installed:
    lib.install 'lib/libwebsockets.dylib'
    (lib+'pkgconfig').install 'libwebsockets.pc'
    include.install 'lib/libwebsockets.h'
  end
end
