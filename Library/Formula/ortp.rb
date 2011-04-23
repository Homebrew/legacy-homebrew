require 'formula'

class Ortp < Formula
  url 'http://download.savannah.gnu.org/releases/linphone/ortp/sources/ortp-0.16.5.tar.gz'
  homepage 'http://www.linphone.org/eng/documentation/dev/ortp.html'
  md5 '94546901d14b85f97342f4ecf39489b1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
