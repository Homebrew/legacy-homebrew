class Libowfat < Formula
  desc "Reimplements libdjb"
  homepage "https://www.fefe.de/libowfat/"
  head ":pserver:cvs:@cvs.fefe.de:/cvs", :using => :cvs
  url "https://dl.fefe.de/libowfat-0.29.tar.bz2"
  sha256 "4badbdeed6bef4337f1edd6b86fb7154c5592509c272dcdc09c693161cbc6427"

  bottle do
    cellar :any
    revision 1
    sha256 "38df950df07f7c18a5ddb953eed10e37519d8fec707d1b8debf33f541a92eaeb" => :yosemite
    sha256 "dece66a8665d9fd69fff3504d19eee4f0689c2afeb818ff8567b311eaf34e9ec" => :mavericks
    sha256 "32a8ba6a9e3aae2a75f2c44712b9e99b1981084f6c475c1829f235ed10df2bda" => :mountain_lion
  end

  def install
    system "make", "libowfat.a"
    system "make", "install", "prefix=#{prefix}", "MAN3DIR=#{man3}", "INCLUDEDIR=#{include}/libowfat"
  end
end
