require 'formula'

class Libbind < Formula
  homepage 'https://www.isc.org/software/libbind'
  url 'ftp://ftp.isc.org/isc/libbind/6.0/libbind-6.0.tar.gz'
  sha1 '4664646238cd3602df168da1e9bc9591d3f566b2'

  bottle do
    cellar :any
    revision 1
    sha1 "30bbab51056974792200006da34d57aa8285c919" => :yosemite
    sha1 "aa5d280d0970c79875c203279c4dcec9d3a7b226" => :mavericks
    sha1 "aa9b1682a17d2c1df60af9240e623f6d37bd47dd" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make" # You need to call make, before you can call make install
    system "make install"
  end
end
