require 'formula'

class Tractorgen < Formula
  homepage 'http://www.vergenet.net/~conrad/software/tractorgen/'
  url 'http://www.vergenet.net/~conrad/software/tractorgen/dl/tractorgen-0.31.7.tar.gz'
  sha1 '7d5d0c84a030a71840ee909b2124797b5281ddcc'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
