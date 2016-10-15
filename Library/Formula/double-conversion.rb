require "formula"

class DoubleConversion < Formula
  homepage "https://code.google.com/p/double-conversion/"
  url "https://double-conversion.googlecode.com/files/double-conversion-1.1.5.tar.gz"
  sha1 "7a4ca234bfe93e178056aef6ece97a869923cdb6"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_TESTING=ON"
    system "make", "install"
    system "set -o pipefail; test/cctest/cctest --list | tr -d '<' | xargs test/cctest/cctest"
  end
end
