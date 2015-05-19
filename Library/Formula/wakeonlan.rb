require "formula"

class Wakeonlan < Formula
  desc "Sends magic packets to wake up network-devices"
  homepage "https://github.com/jpoliv/wakeonlan"
  url "https://github.com/jpoliv/wakeonlan/archive/wakeonlan-0.41.tar.gz"
  sha1 "5937a27e818f4765e3bc8fd6742375240a90d5d1"

  def install
    system "perl", "Makefile.PL"
    system "make"
    bin.install "blib/script/wakeonlan"
    man1.install "blib/man1/wakeonlan.1"
  end
end
