require "formula"

class Xrootd < Formula
  homepage "http://xrootd.org"
  url "http://xrootd.org/download/v4.0.4/xrootd-4.0.4.tar.gz"
  sha1 "e19432bfc016319f6e653674cfe71b308b296925"

  bottle do
    cellar :any
    sha1 "755130a388fb467ddaf44a93494172876ba9af71" => :yosemite
    sha1 "26bcf7eff4cf9dc93ba5940764ed5671fe1fe1d9" => :mavericks
    sha1 "f5f476756b9f03fa0c3900861c08b28237c6c330" => :mountain_lion
  end

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
