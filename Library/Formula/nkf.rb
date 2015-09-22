class Nkf < Formula
  desc "Network Kanji code conversion Filter (NKF)"
  homepage "https://osdn.jp/projects/nkf/"
  url "http://dl.osdn.jp/nkf/59912/nkf-2.1.3.tar.gz"
  sha256 "8cb430ae69a1ad58b522eb4927b337b5b420bbaeb69df255919019dc64b72fc2"

  bottle do
    cellar :any_skip_relocation
    sha256 "7070e1471fda6cf7b479b0ba5a58915c301b1b25ca2ddaed854eaa7273e1afa9" => :el_capitan
    sha1 "ebad3eb906da012ffc5c1167fdc9d75221471394" => :yosemite
    sha1 "779ab5fa155cba57c42cd877beafa980c2ebccff" => :mavericks
    sha1 "760761c7977133b623449c75631019a23186ad3d" => :mountain_lion
  end

  def install
    inreplace "Makefile", "$(prefix)/man", "$(prefix)/share/man"
    system "make", "CC=#{ENV.cc}"
    # Have to specify mkdir -p here since the intermediate directories
    # don't exist in an empty prefix
    system "make", "install", "prefix=#{prefix}", "MKDIR=mkdir -p"
  end
end
