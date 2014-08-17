require "formula"

class Xrootd < Formula
  homepage "http://xrootd.org"
  url "http://xrootd.org/download/v4.0.2/xrootd-4.0.2.tar.gz"
  sha1 "91b2193014b60d3d0430cf213d714822e3a14583"

  depends_on "cmake" => :build

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
