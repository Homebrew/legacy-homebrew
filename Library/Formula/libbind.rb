require 'formula'

class Libbind < Formula
  homepage 'https://www.isc.org/software/libbind'
  url 'ftp://ftp.isc.org/isc/libbind/6.0/libbind-6.0.tar.gz'
  sha1 '4664646238cd3602df168da1e9bc9591d3f566b2'

  if build.head?
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make" # You need to call make, before you can call make install
    system "make install"
  end
end
