require 'formula'

class Svg2png < Formula
  homepage 'http://cairographics.org/'
  url 'http://cairographics.org/snapshots/svg2png-0.1.3.tar.gz'
  sha1 'afd207ef745fe2e20e01585bbc9a576e7cc9caf5'

  depends_on 'pkg-config' => :build
  depends_on 'libsvg-cairo'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
