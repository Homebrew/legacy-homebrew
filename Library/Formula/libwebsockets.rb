require 'formula'

class Libwebsockets < Formula
  homepage 'http://libwebsockets.org'
  url 'http://git.libwebsockets.org/cgi-bin/cgit/libwebsockets/snapshot/libwebsockets-1.23-chrome32-firefox24.tar.gz'
  version '1.23'
  sha1 '9dda683a342b16feb1cef183f89f9ed4474626f5'
  head 'git://git.libwebsockets.org/libwebsockets'

  bottle do
    cellar :any
    sha1 "c295450e05099c9cec0dd0e3a099f92d6ab8dc34" => :mavericks
    sha1 "0648d6f48e80d5d3a484d4174628b0deec52a1b4" => :mountain_lion
    sha1 "56b5ab3c2e876ee12f5955c37d3b06a175faccce" => :lion
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
