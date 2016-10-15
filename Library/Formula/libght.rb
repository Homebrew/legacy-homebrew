require "formula"

class Libght < Formula
  homepage "https://github.com/pramsey/libght"
  url "https://github.com/pramsey/libght/archive/v0.1.0.tar.gz"
  sha1 "19104cdba21fabb8d5fad847af1a8e8bcde40b6a"

  head "https://github.com/pramsey/libght.git"

  depends_on "cmake" => :build
  depends_on "cunit" => :build
  depends_on "liblas" => :recommended
  depends_on "libxml2"
  depends_on "proj" => :recommended

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
