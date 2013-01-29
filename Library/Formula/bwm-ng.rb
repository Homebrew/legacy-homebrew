require 'formula'

class BwmNg < Formula
  homepage 'http://www.gropp.org/?id=projects&sub=bwm-ng'
  url 'http://www.gropp.org/bwm-ng/bwm-ng-0.6.tar.gz'
  sha1 '90bab1837f179fa1fe0d4b8bad04072affa39c01'

  fails_with :clang do
    build 421
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
