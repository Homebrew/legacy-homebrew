require "formula"

class Xrootd < Formula
  homepage "http://xrootd.org"
  url "http://xrootd.org/download/v4.0.3/xrootd-4.0.3.tar.gz"
  sha1 "e03d7dde9b7510c518b03b01b018ca4f1fba867f"

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
