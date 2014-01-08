require 'formula'

class Ortp < Formula
  homepage 'http://www.linphone.org/eng/documentation/dev/ortp.html'
  url 'http://download.savannah.gnu.org/releases/linphone/ortp/sources/ortp-0.22.0.tar.gz'
  sha1 '3f4712307ceba27c6498abd2090f411e02084dbd'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
