require "formula"

class Sfml < Formula
  homepage "http://www.sfml-dev.org/"
  url "http://www.sfml-dev.org/download/sfml/2.1/SFML-2.1-sources.zip"
  sha1 "c27bdffdc4bedb5f6a20db03ceca715d42aa5752"

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "glew"
  depends_on "jpeg"
  depends_on "libsndfile"

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_FRAMEWORK_PREFIX=#{frameworks}/", *std_cmake_args
    system "make", "install"
  end
end
