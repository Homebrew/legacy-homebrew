require 'formula'

class Giflib < Formula
  homepage 'http://giflib.sourceforge.net/'
  # 4.2.0 has breaking API changes; don't update until
  # things in $(brew uses giflib) are compatible
  url 'http://downloads.sourceforge.net/project/giflib/giflib-4.x/giflib-4.1.6/giflib-4.1.6.tar.bz2'
  sha1 '22680f604ec92065f04caf00b1c180ba74fb8562'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
