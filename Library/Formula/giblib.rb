require 'formula'

class Giblib < Formula
  url 'http://linuxbrit.co.uk/downloads/giblib-1.2.4.tar.gz'
  homepage 'http://freshmeat.net/projects/giblib'
  md5 'c810ef5389baf24882a1caca2954385e'

  depends_on 'imlib2' => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
