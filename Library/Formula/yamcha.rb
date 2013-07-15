require 'formula'

class Yamcha < Formula
  homepage 'http://chasen.org/~taku/software/yamcha/'
  url 'http://chasen.org/~taku/software/yamcha/src/yamcha-0.33.tar.gz'
  sha1 '4ee6d8150557761f86fcb8af118636b7c23920c0'

  depends_on "tinysvm"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
