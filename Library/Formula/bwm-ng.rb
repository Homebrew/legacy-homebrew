require 'formula'

class BwmNg < Formula
  url 'http://www.gropp.org/bwm-ng/bwm-ng-0.6.tar.gz'
  homepage 'http://www.gropp.org/?id=projects&sub=bwm-ng'
  md5 'd3a02484fb7946371bfb4e10927cebfb'

  def install
    if MacOS.default_compiler == :clang
      # auto-retest next clang version, submit patch if fails!
      ENV.llvm if MacOS.clang_version.to_f <= 3.1
    end

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
