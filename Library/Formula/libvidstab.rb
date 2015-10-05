class Libvidstab < Formula
  desc "Transcode video stabilization plugin"
  homepage "http://public.hronopik.de/vid.stab/"
  url "https://github.com/georgmartius/vid.stab/archive/release-0.98b.tar.gz"
  sha256 "530f0bf7479ec89d9326af3a286a15d7d6a90fcafbb641e3b8bdb8d05637d025"

  bottle do
    cellar :any
    revision 1
    sha256 "25aba597740cf9b793997d8fb1d741d97fe24948967c8d0c232ea55fa9f7839f" => :el_capitan
    sha1 "57958e5826781bbf10929f918c36a2ac54dc52bd" => :yosemite
    sha1 "be60ee3921484efe3f90495b24046437c84498b5" => :mavericks
    sha1 "05e50798e9cf4120ae96dba00f1fed578f481cf0" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
