require "formula"

class Libewf < Formula
  homepage "http://code.google.com/p/libewf/"
  url "https://googledrive.com/host/0B3fBvzttpiiSMTdoaVExWWNsRjg/libewf-20140608.tar.gz"
  sha1 "c17384a3d2c1d63bd5b1aaa2aead6ee3c82a2368"

  bottle do
    cellar :any
    revision 1
    sha1 "402eaa3c798f989cdaaea037aa4042813f27a19c" => :yosemite
    sha1 "efc08c4c055d93a533e833fa99339d29bd12aee2" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
