require "formula"

class Polarssl < Formula
  homepage "https://polarssl.org/"
  url "https://polarssl.org/download/polarssl-1.3.8-gpl.tgz"
  sha1 "82ed8ebcf3dd53621da5395b796fc0917083691d"

  head "https://github.com/polarssl/polarssl.git"

  depends_on "cmake" => :build

  conflicts_with "md5sha1sum", :because => "both install conflicting binaries"
  conflicts_with "hello", :because => "both install GNU hello binaries"

  def install
    system "cmake", ".",  *std_cmake_args
    system "make"
    system "make", "install"
  end
end
