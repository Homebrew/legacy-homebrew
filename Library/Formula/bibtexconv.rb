require 'formula'

class Bibtexconv < Formula
  homepage 'http://www.iem.uni-due.de/~dreibh/bibtexconv/'
  url 'http://www.iem.uni-due.de/~dreibh/bibtexconv/download/bibtexconv-0.9.4.tar.gz'
  sha1 'd743e9cfb5afd99cbb224c59c1a731db21ce2f4e'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

end
