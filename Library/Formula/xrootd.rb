require "formula"

class Xrootd < Formula
  homepage "http://xrootd.org"
  url "http://xrootd.org/download/v4.0.0/xrootd-4.0.0.tar.gz"
  sha1 "3d2a46756253075ebe05d94b1a547914d39f9b22"

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
