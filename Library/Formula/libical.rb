require "formula"

class Libical < Formula
  homepage "http://www.citadel.org/doku.php/documentation:featured_projects:libical"
  url "https://github.com/libical/libical/releases/download/v1.0.1/libical-1.0.1.tar.gz"
  sha1 "904b2c2b5c2b30f0a508f9d56eaf316dd42fc923"

  depends_on "cmake" => :build

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DSHARED_ONLY=true"
    cmake_args << ".."
    mkdir 'build' do
      system "cmake", *cmake_args
      system "make install"
    end
  end
end
