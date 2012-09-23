require 'formula'

class BwmNg < Formula
  url 'http://www.gropp.org/bwm-ng/bwm-ng-0.6.tar.gz'
  homepage 'http://www.gropp.org/?id=projects&sub=bwm-ng'
  sha1 '90bab1837f179fa1fe0d4b8bad04072affa39c01'

  fails_with :clang do
    build 318
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
