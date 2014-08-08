require "formula"

class Tbb < Formula
  homepage "http://www.threadingbuildingblocks.org/"
  url "https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb42_20140601oss_src.tgz"
  sha1 "f50c04a27f5e37c920a03be134dc57ccf909515d"
  version "4.2.5"

  option :cxx11

  def install
    # Intel sets varying O levels on each compile command.
    ENV.no_optimization

    args = %W[tbb_build_prefix=BUILDPREFIX]

    case ENV.compiler
    when :clang
      args << "compiler=clang"
    else
      args << "compiler=gcc"
    end

    if MacOS.prefer_64_bit?
      args << "arch=intel64"
    else
      args << "arch=ia32"
    end

    if build.cxx11?
      ENV.cxx11
      args << "cpp0x=1" << "stdlib=libc++"
    end

    system "make", *args
    lib.install Dir["build/BUILDPREFIX_release/*.dylib"]
    include.install "include/tbb"
  end
end
