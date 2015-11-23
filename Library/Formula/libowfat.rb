class Libowfat < Formula
  desc "Reimplements libdjb"
  homepage "http://www.fefe.de/libowfat/"
  head ":pserver:cvs:@cvs.fefe.de:/cvs", :using => :cvs
  url "http://dl.fefe.de/libowfat-0.29.tar.bz2"
  sha256 "4badbdeed6bef4337f1edd6b86fb7154c5592509c272dcdc09c693161cbc6427"

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
