class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "http://freecode.com/projects/fio"
  url "http://brick.kernel.dk/snaps/fio-2.2.9.tar.bz2"
  sha256 "c881d9cf15500bd4436970d0467c356c5c021417131587931ba78845e965bf56"
  head "git://git.kernel.dk/fio.git"

  bottle do
    cellar :any
    sha256 "afacb2020505d8b1476c2822c13cd9793662c7c88ce445e2a735d4fbb2cd1cc0" => :yosemite
    sha256 "bab17199f99db3192d81d05adc61c35f39098b343bd4876434beb0125b44652b" => :mavericks
    sha256 "6614227f2226a9989de3441ca3be6dc061cbaad3cdabd72e68e9329f061b0e04" => :mountain_lion
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
