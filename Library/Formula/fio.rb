class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "http://freecode.com/projects/fio"
  url "http://brick.kernel.dk/snaps/fio-2.2.10.tar.bz2"
  sha256 "04b4490c69f82bafeccbab51d33732cfd74e7a54e74eae0d9a2450faf4f1d857"
  head "git://git.kernel.dk/fio.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6448ccce823cf08fdde3faec01d13ec9d887728c12715bd53e229e2a4d4e095e" => :el_capitan
    sha256 "2ce16b27e45a0816402e3e255327e900c85f5b1004ab5927903cef9a20de1186" => :yosemite
    sha256 "6e59bf79cec9bb83b2a8cf2587a4da94bfde9ab10596f3f08143049ae6a2c094" => :mavericks
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
