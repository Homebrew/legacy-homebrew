require 'formula'

class Chordii < Formula
  homepage 'http://www.vromans.org/johan/projects/Chordii/'
  url 'http://downloads.sourceforge.net/project/chordii/chordii/4.3/chordii-4.3.tar.gz'
  version '4.3'
  sha1 '4f959aee0db7c80f2c55441b93fe1a9abdbcdca3'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install" # if this fails, try separate make/make install steps
  end

end
