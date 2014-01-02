require 'formula'

class Argus < Formula
  homepage 'http://qosient.com/argus/'
  url 'http://qosient.com/argus/src/argus-3.0.6.1.tar.gz'
  sha1 '0da193957510fbe1b72875d4ea205453cb7821be'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
