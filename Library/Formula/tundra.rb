require 'formula'

class Tundra < Formula
  url 'https://github.com/deplinenoise/tundra/tarball/v0.99a'
  version '0.99a'
  homepage 'http://github.com/deplinenoise/tundra'
  md5 '7c2914d1cc99129c295d96e8fed1b702'

  depends_on 'cmake'

  def install
    system "mkdir build && (cd build && cmake .. #{std_cmake_parameters} && make)"
    system "TUNDRA_HOME=$PWD build/tundra release standalone"
    system "mkdir -p #{prefix}/bin"
    system "cp -p tundra-output/macosx-clang-release-standalone/tundra #{prefix}/bin/tundra"
  end
end
