require 'formula'

class Lzo < Formula
  homepage 'http://www.oberhumer.com/opensource/lzo/'
  url 'http://www.oberhumer.com/opensource/lzo/download/lzo-2.06.tar.gz'
  sha256 'ff79e6f836d62d3f86ef6ce893ed65d07e638ef4d3cb952963471b4234d43e73'

  bottle do
    cellar :any
    sha1 "39b3bddecc7646bac80d1b12931148932b9ff6b1" => :mavericks
    sha1 "0a752df8103e1020b2d8d7fa9fa0a8ce59f9cddc" => :mountain_lion
    sha1 "d88d2c7a55df8acf9cdfe7b3438e04c07e284adc" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make check"
    system "make install"
  end
end
