class Csync < Formula
  desc "File synchronizer especially designed for normal users"
  homepage "https://www.csync.org/"
  url "https://open.cryptomilk.org/attachments/download/27/csync-0.50.0.tar.xz"
  sha256 "c07526942a93c1e213d354dc45fd61fbc0430c60e109e7a2f0fcaf6213a45c86"

  head "git://git.csync.org/projects/csync.git"

  bottle do
    sha256 "7cb352d5d69d7058522ee92647b7b44e6e6b27ae936adfef57dfc65b7614ce15" => :el_capitan
    sha256 "6fb34b42a41eb68c1d05f232aab49b71eb9e3030a78e11fa28d65b3792024db7" => :yosemite
    sha256 "41f5ceb9468dc7d2f4fd8048778fde8ec0395f79ce9ee9af36bfb33b77178c7f" => :mavericks
    sha256 "8550caddfd1c8ed531abdb79b5955292977c9adb19adab91b1acd50f27b8d27f" => :mountain_lion
  end

  depends_on "check" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => [:build, :optional]
  depends_on "argp-standalone"
  depends_on "iniparser"
  depends_on "sqlite"
  depends_on "libssh" => :optional
  depends_on "log4c" => :optional
  depends_on "samba" => :optional

  depends_on :macos => :lion

  def install
    mkdir "build" unless build.head?
    cd "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "all"
      system "make", "install"
    end
  end

  test do
    system bin/"csync", "-V"
  end
end
