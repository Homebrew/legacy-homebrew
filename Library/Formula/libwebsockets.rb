require 'formula'

class Libwebsockets < Formula
  homepage 'http://libwebsockets.org'
  url 'http://git.libwebsockets.org/cgi-bin/cgit/libwebsockets/snapshot/libwebsockets-1.4-chrome43-firefox-36.tar.gz'
  version '1.4'
  sha1 'f2c4cb05abb3ddac09a61f63cbd018665da2d450'
  head 'git://git.libwebsockets.org/libwebsockets'

  depends_on "openssl"

  bottle do
    sha1 "9d58b15a1b6cc37aac8871ec8ab7553a2931db1f" => :yosemite
    sha1 "c33cac4bae88d866c7b318dbf0a4dc8ddbd23bbd" => :mavericks
    sha1 "bf670cf9c8dd17ce92f60fdb52af8745250f6ea2" => :mountain_lion
  end

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end
end
