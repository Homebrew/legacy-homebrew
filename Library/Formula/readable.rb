require "formula"

class Readable < Formula
  homepage "http://readable.sourceforge.net"
  url "https://downloads.sourceforge.net/sourceforge/readable/readable-1.0.0.tar.gz"
  sha1 "19b56d4cf38ecd87137472bfdbfc5628b822a37b"

  depends_on "guile"

  def install
    system "./configure", "--without-common-lisp",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/unsweeten", "--version"
  end
end
