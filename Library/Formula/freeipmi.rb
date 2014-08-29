require "formula"

class Freeipmi < Formula
  homepage "https://www.gnu.org/software/freeipmi/"
  url "http://ftpmirror.gnu.org/freeipmi/freeipmi-1.4.5.tar.gz"
  mirror "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.4.5.tar.gz"
  sha1 "21f567f452de53545a8880eaf572cad567e5ad30"

  bottle do
    sha1 "104f68c5dd708695dcfda6d569705230c3c57437" => :mavericks
    sha1 "eb04bd6b79908fca5ed724806d7be2a28431eefc" => :mountain_lion
    sha1 "e0eb9b03feb21fdb6262c6feb35a45acf79fb022" => :lion
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
