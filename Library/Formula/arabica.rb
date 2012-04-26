require 'formula'

class Arabica < Formula
  homepage 'http://www.jezuk.co.uk/cgi-bin/view/arabica'
  url 'https://github.com/ashb/Arabica/tarball/20100203'
  md5 '9318c4d498957cd356e533f2132d6956'

  if MacOS.xcode_version >= "4.3"
    # remove the autoreconf if possible, no comment provided about why it is there
    # so we have no basis to make a decision at this point.
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf"
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
