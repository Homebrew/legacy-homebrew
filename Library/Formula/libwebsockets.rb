class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "http://git.libwebsockets.org/cgi-bin/cgit/libwebsockets/snapshot/libwebsockets-1.6.2.tar.gz"
  sha256 "cdc54444f5bf5a74d2b6d81f40a9081d7e6c2ae88a0c5f09e3fdfc5c77e65860"
  head "git://git.libwebsockets.org/libwebsockets"

  depends_on "openssl"

  bottle do
    sha256 "a75859658c26c0d2f74e53ffb111bf8d7160b6e167665c4131729f3d4d293236" => :el_capitan
    sha256 "1b9a456a63f0084b525aa5219aea58c3a2ccaaaa3659a7b6d2a8a0c0f8db068a" => :yosemite
    sha256 "57473c1cc3496eef606c827d19b823ba7f68ef03c8eace90808b89d65780a893" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end
end
