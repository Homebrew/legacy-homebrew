require 'formula'

class BwmNg < Formula
  url 'http://www.gropp.org/bwm-ng/bwm-ng-0.6.tar.gz'
  homepage 'http://www.gropp.org/?id=projects&sub=bwm-ng'
  md5 'd3a02484fb7946371bfb4e10927cebfb'

  fails_with :clang do
    build 318
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
