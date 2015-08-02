require 'formula'

class BwmNg < Formula
  desc "Console-based live network and disk I/O bandwidth monitor"
  homepage 'http://www.gropp.org/?id=projects&sub=bwm-ng'
  url 'http://www.gropp.org/bwm-ng/bwm-ng-0.6.tar.gz'
  sha1 '90bab1837f179fa1fe0d4b8bad04072affa39c01'

  def install
    ENV.append 'CFLAGS', '-std=gnu89'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
