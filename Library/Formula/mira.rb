require 'formula'

class Mira < Formula
  url 'http://downloads.sourceforge.net/project/mira-assembler/MIRA/stable/mira-3.4.0.tar.bz2'
  homepage 'http://sourceforge.net/apps/mediawiki/mira-assembler/'
  md5 '4cebaca9e760180c9fa7ed30be8fc178'

  depends_on 'boost'
  depends_on 'google-perftools'
  depends_on 'docbook'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    # Can't use because of absent of dblatex
    #system "make docs"
  end

  def test
    system "mira"
  end
end
