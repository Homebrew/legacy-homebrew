require 'formula'

class Wordnet < Formula
  homepage 'http://wordnet.princeton.edu/'
  url 'http://wordnetcode.princeton.edu/3.0/WordNet-3.0.tar.bz2'
  sha1 'aeb7887cb4935756cf77deb1ea86973dff0e32fb'

  depends_on :x11

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    ENV.deparallelize
    system "make install"
  end
end
