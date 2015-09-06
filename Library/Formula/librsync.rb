class Librsync < Formula
  desc "Library that implements the rsync remote-delta algorithm"
  homepage "http://librsync.sourceforge.net/"
  url "https://github.com/librsync/librsync/archive/v2.0.0.tar.gz"
  sha256 "b5c4dd114289832039397789e42d4ff0d1108ada89ce74f1999398593fae2169"

  bottle do
    cellar :any
    revision 1
    sha256 "12560a233362faa837f9ade76bc4e0018b02fe872cb7f7b3b45351c24a09ec10" => :el_capitan
    sha256 "89629dde5a47b7da9990f4e2c1804215f1326c302a53312e7c2a3a917aa5d855" => :yosemite
    sha256 "d8afefbdd50533a2198376e3f0cadbb2e128c32bc3ad8d1f39fb338fb3ae3fb3" => :mavericks
    sha256 "629cc851c9096a8c815c3c4e93ee0914d8f66039acfff0ade225a0b02b5dfaa7" => :mountain_lion
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
