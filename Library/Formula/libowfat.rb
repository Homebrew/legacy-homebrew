require 'formula'

class Libowfat < Formula
  homepage 'http://www.fefe.de/libowfat/'
  head 'cvs://:pserver:cvs:@cvs.fefe.de:/cvs:libowfat'
  url 'http://dl.fefe.de/libowfat-0.29.tar.bz2'
  sha1 'f944ebac326f4a8bd1437ff995d0b8201280434c'

  bottle do
    cellar :any
    revision 1
    sha1 "e586ec2dc7100d76ab4e497cbacbe758f71615d1" => :yosemite
    sha1 "7b9763c60837442c76969807ea9ac4d0b6e90a61" => :mavericks
    sha1 "e19086b40e28e750e907d14ee89806819c48d964" => :mountain_lion
  end

  def install
    system "make", "libowfat.a"
    system "make", "install", "prefix=#{prefix}", "MAN3DIR=#{man3}", "INCLUDEDIR=#{include}/libowfat"
  end
end
