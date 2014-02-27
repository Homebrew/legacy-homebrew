require 'formula'

class Bogofilter < Formula
  homepage 'http://bogofilter.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/bogofilter/bogofilter-1.2.4/bogofilter-1.2.4.tar.bz2'
  sha1 'f51c02162fc31116e583197840a87d76ddcb9536'

  depends_on 'berkeley-db'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
