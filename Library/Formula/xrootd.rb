require "formula"

class Xrootd < Formula
  homepage "http://xrootd.org"
  url "http://xrootd.org/download/v4.0.4/xrootd-4.0.4.tar.gz"
  sha1 "e19432bfc016319f6e653674cfe71b308b296925"

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
    share.install prefix/"man"
  end

  test do
    system "#{bin}/xrootd", "-H"
  end
end
