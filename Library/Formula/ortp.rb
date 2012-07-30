require 'formula'

class Ortp < Formula
  homepage 'http://www.linphone.org/eng/documentation/dev/ortp.html'
  url 'http://download.savannah.gnu.org/releases/linphone/ortp/sources/ortp-0.20.0.tar.gz'
  sha1 '9c66fb9512134869d4d2eb7766b6a8c5e4da1cc7'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
