require "formula"

class Tbb < Formula
  homepage "http://www.threadingbuildingblocks.org/"
  url "https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb43_20140724oss_src.tgz"
  sha1 "4cb73cd0ac61b790318358ae4782f80255715278"
  version "4.3-20140724"

  bottle do
    cellar :any
    sha1 "500a19e3b12c7ecd04d09c558403b03dabaef465" => :mavericks
    sha1 "17194db68fe3dc0a932094f04776bc5c7eee756d" => :mountain_lion
    sha1 "2bb200abaf9f8182bfb948e4dee513b9afca2198" => :lion
  end

  # requires malloc features first introduced in Lion
  # https://github.com/Homebrew/homebrew/issues/32274
  depends_on :macos => :lion

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
