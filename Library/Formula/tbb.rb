require "formula"

class Tbb < Formula
  homepage "http://www.threadingbuildingblocks.org/"
  url "https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb42_20140601oss_src.tgz"
  sha1 "f50c04a27f5e37c920a03be134dc57ccf909515d"
  version "4.2.5"

  bottle do
    cellar :any
    sha1 "1acf91deb5540f1ed153c3ece947146f84e52946" => :mavericks
    sha1 "0e2799b23f8a7ee446fe49b986d1d8cc308ae755" => :mountain_lion
    sha1 "626775355972feb9cbcf7a786c109112f36fd746" => :lion
  end

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
