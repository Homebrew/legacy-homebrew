require 'formula'

class Libwebsockets < Formula
  homepage 'http://libwebsockets.org'
  url 'http://git.libwebsockets.org/cgi-bin/cgit/libwebsockets/snapshot/libwebsockets-1.3-chrome37-firefox30.tar.gz'
  version '1.3'
  sha1 'ee1005165346d2217db4a9c40c4711f741213557'
  head 'git://git.libwebsockets.org/libwebsockets'

  depends_on "openssl"

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
    system "make", "install"
  end
end
