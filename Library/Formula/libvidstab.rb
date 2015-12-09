class Libvidstab < Formula
  desc "Transcode video stabilization plugin"
  homepage "http://public.hronopik.de/vid.stab/"
  url "https://github.com/georgmartius/vid.stab/archive/release-0.98b.tar.gz"
  sha256 "530f0bf7479ec89d9326af3a286a15d7d6a90fcafbb641e3b8bdb8d05637d025"

  bottle do
    cellar :any
    revision 1
    sha256 "25aba597740cf9b793997d8fb1d741d97fe24948967c8d0c232ea55fa9f7839f" => :el_capitan
    sha256 "9c20b222d86c69f675ff12cdd23689009dc6c007fd5ee8db22d4195eca770ee1" => :yosemite
    sha256 "9b1e3aa9d03c9a5f3dcb0e4632ffe36ed2e1ccc131b7e5b977ea7143e33ce5af" => :mavericks
    sha256 "73077db3e1a9effb890277b6b20be38f20e6924704f5c8b347806f2527d14662" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
