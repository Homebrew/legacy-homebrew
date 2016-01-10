class Librsync < Formula
  desc "Library that implements the rsync remote-delta algorithm"
  homepage "http://librsync.sourceforge.net/"
  url "https://github.com/librsync/librsync/archive/v2.0.0.tar.gz"
  sha256 "b5c4dd114289832039397789e42d4ff0d1108ada89ce74f1999398593fae2169"

  bottle do
    sha256 "7205930ff0e86bee031c515209bfb8ef9920274420eaa23701756ce4ae32fb15" => :el_capitan
    sha256 "d7e0a7ac12e5ba12b145aa6bfb0003c2b36d0ec80c5801f1600c325204f76b26" => :yosemite
    sha256 "ada01ecda22ddb6dafeb6a01847244442e831993915b91a4c850d5b7b32b6696" => :mavericks
  end

  option :universal

  depends_on "cmake" => :build
  depends_on "popt"

  def install
    ENV.universal_binary if build.universal?

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
