require 'formula'

class Crfsuite < Formula
  homepage 'http://www.chokkan.org/software/crfsuite'
  url 'https://github.com/downloads/chokkan/crfsuite/crfsuite-0.12.tar.gz'
  sha1 'd27f6a056c30ddc53c469fd5d92e6631614bdcc2'

  depends_on 'liblbfgs'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
