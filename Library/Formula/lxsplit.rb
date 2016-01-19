class Lxsplit < Formula
  desc "Tool for splitting or joining files"
  homepage "http://lxsplit.sourceforge.net/"
  url "https://downloads.sourceforge.net/lxsplit/lxsplit-0.2.4.tar.gz"
  sha256 "858fa939803b2eba97ccc5ec57011c4f4b613ff299abbdc51e2f921016845056"

  def install
    bin.mkpath
    inreplace "Makefile", "/usr/local/bin", bin
    system "make"
    system "make", "install"
  end
end
