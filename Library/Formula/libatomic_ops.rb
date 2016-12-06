require 'formula'

class LibatomicOps < Formula
  homepage 'http://www.hpl.hp.com/research/linux/atomic_ops/'
  url 'http://www.hpl.hp.com/research/linux/atomic_ops/download/libatomic_ops-7.2d.tar.gz'
  sha1 'ed5bb963648bdfb87fc815a9037114654d164907'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
