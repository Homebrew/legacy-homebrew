require 'formula'

class Wxmaxima < Formula
  homepage 'http://andrejv.github.com/wxmaxima'
  url 'https://sourceforge.net/projects/wxmaxima/files/wxMaxima/12.09.0/wxMaxima-12.09.0.tar.gz'
  sha1 '9b56f674392eabb75183b228757df8834b45b2a6'

  depends_on 'wxmac'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system 'make'
    cd 'locales' do
      system 'make', 'allmo'
    end
    system 'make', 'wxMaxima.app'
    prefix.install 'wxMaxima.app'
    system "make install"
  end
end
