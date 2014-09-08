require 'formula'

class Libowfat < Formula
  homepage 'http://www.fefe.de/libowfat/'
  head 'cvs://:pserver:cvs:@cvs.fefe.de:/cvs:libowfat'
  url 'http://dl.fefe.de/libowfat-0.29.tar.bz2'
  sha1 'f944ebac326f4a8bd1437ff995d0b8201280434c'

  bottle do
    cellar :any
    sha1 "dd02ebb4edaef0a6c35f3d1833661811d31bd95c" => :mavericks
    sha1 "13ca1fef9ce70e49f5016c2f5a3a887ced90fcf6" => :mountain_lion
    sha1 "5a9ba3731c9953a4ee08c3a8c011c38de70f64b1" => :lion
  end

  def install
    system "make", "libowfat.a"
    system "make", "install", "prefix=#{prefix}", "MAN3DIR=#{man3}", "INCLUDEDIR=#{include}/libowfat"
  end
end
