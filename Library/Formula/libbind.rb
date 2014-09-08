require 'formula'

class Libbind < Formula
  homepage 'https://www.isc.org/software/libbind'
  url 'ftp://ftp.isc.org/isc/libbind/6.0/libbind-6.0.tar.gz'
  sha1 '4664646238cd3602df168da1e9bc9591d3f566b2'

  bottle do
    cellar :any
    sha1 "ab579c0bea90bde0b211f2c2c4ad93ffcc3361ce" => :mavericks
    sha1 "cb656e8d005bbf7dad9f73186b2a385d1fe77315" => :mountain_lion
    sha1 "21eb2174ad985ba5d9574f747bfe9d2621cd7c8e" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make" # You need to call make, before you can call make install
    system "make install"
  end
end
