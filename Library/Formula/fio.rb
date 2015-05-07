class Fio < Formula
  homepage "http://freecode.com/projects/fio"
  url "http://brick.kernel.dk/snaps/fio-2.2.7.tar.bz2"
  sha256 "6e3cd5bda0747e61cbfd42c7b3cfe044ea8981d8d3a486f0a2f2fafdb954296f"
  head "git://git.kernel.dk/fio.git"

  bottle do
    cellar :any
    sha1 "3509a6a952469c90d80aac04af18c6611db8c66a" => :yosemite
    sha1 "2069309ce6c0a96311dcdd67b95c88e34cfcde84" => :mavericks
    sha1 "8f12a0d2f33c0a33102a5901b4e9a6c8cf7d73e8" => :mountain_lion
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
