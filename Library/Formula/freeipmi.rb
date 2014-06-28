require "formula"

class Freeipmi < Formula
  homepage "https://www.gnu.org/software/freeipmi/"
  url "http://ftpmirror.gnu.org/freeipmi/freeipmi-1.4.4.tar.gz"
  mirror "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.4.4.tar.gz"
  sha1 "343b574ca79038d22827c895ef0ca95ee38137ae"

  bottle do
    sha1 "1ac5427faba16ce4beafbc447c068d37cf9c3493" => :mavericks
    sha1 "0503402e0b8ed546db82808852396afbbd29e37b" => :mountain_lion
    sha1 "94f888c548f17d7a3e06397353a4e768f1b20b8a" => :lion
  end

  depends_on "argp-standalone"
  depends_on "libgcrypt"

  def install
    system "./configure", "--prefix=#{prefix}"
    # This is a big hammer to disable building the man pages
    # It breaks under homebrew's build system and I'm not sure why
    inreplace "man/Makefile", "install: install-am", "install:"
    system "make", "install"
  end

  test do
    system "#{sbin}/ipmi-fru", "--version"
  end
end
