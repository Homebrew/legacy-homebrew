require 'formula'

class Arabica < Formula
  homepage 'http://www.jezuk.co.uk/cgi-bin/view/arabica'
  url 'https://github.com/ashb/Arabica/tarball/20100203'
  version '20100203'
  md5 '9318c4d498957cd356e533f2132d6956'

  def install
    system "autoreconf"
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
