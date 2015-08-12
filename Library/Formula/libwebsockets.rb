class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "http://git.libwebsockets.org/cgi-bin/cgit/libwebsockets/snapshot/libwebsockets-1.6.2.tar.gz"
  sha256 "cdc54444f5bf5a74d2b6d81f40a9081d7e6c2ae88a0c5f09e3fdfc5c77e65860"
  head "git://git.libwebsockets.org/libwebsockets"

  depends_on "openssl"

  bottle do
    sha256 "2479ab31e046ae0ff45b48ae5239cedca875e0c7986463f7a1e33b7c29fd9132" => :el_capitan
    sha256 "cc661dc04f206bed0fa7ad223dea38caddd1bcc1a6326b4a6389d3431784ae4e" => :yosemite
    sha256 "0c2ac36a235581f64349501c42796c2a08aea85faedb5080b62cf173d2daa506" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end
end
