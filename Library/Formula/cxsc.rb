require 'formula'

class Cxsc < Formula
  homepage 'http://www2.math.uni-wuppertal.de/~xsc/'
  url 'http://www2.math.uni-wuppertal.de/~xsc/xsc/cxsc/cxsc-2-5-3.tar.gz'
  version '2.5.3'
  sha1 'f722b493a3ef099ef1176acfee95cfbfca522b1e'

  def install
    system "(echo yes; echo gnu; echo no; echo yes; echo -O3; echo 64; echo asm; echo #{prefix}; echo both; echo yes) | ./install_cxsc"
    system "rm #{lib}/libcxsc.so #{lib}/libcxsc.so.2"
    system "mv #{lib}/libcxsc.so.2.5.3 #{lib}/libcxsc.2.5.3.dylib"
    system "ln -s libcxsc.2.5.3.dylib #{lib}/libcxsc.2.dylib"
    system "ln -s libcxsc.2.5.3.dylib #{lib}/libcxsc.dylib"
  end

  def test
    system "true"
  end
end
