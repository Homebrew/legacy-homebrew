class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "http://freecode.com/projects/fio"
  url "http://brick.kernel.dk/snaps/fio-2.2.7.tar.bz2"
  sha256 "6e3cd5bda0747e61cbfd42c7b3cfe044ea8981d8d3a486f0a2f2fafdb954296f"
  head "git://git.kernel.dk/fio.git"

  bottle do
    cellar :any
    sha256 "9627e56c1f5b74afc9af0e2c636f7001f678fb3f891c65a7460380445f62e8d0" => :yosemite
    sha256 "366b0622ac63192a2482e77a04840d2e795223a5bf0d0d2e6fbab46ac6d6fb39" => :mavericks
    sha256 "12c9075cadd1fb68ce4ff23560da9d1a1aa0f357602df9a0973d5edfd3a041a0" => :mountain_lion
  end

  def install
    system "./configure"
    # fio's CFLAGS passes vital stuff around, and crushing it will break the build
    system "make", "prefix=#{prefix}",
                   "mandir=#{man}",
                   "sharedir=#{share}",
                   "CC=#{ENV.cc}",
                   "V=true", # get normal verbose output from fio's makefile
                   "install"
  end

  test do
    system "#{bin}/fio", "--parse-only"
  end
end
