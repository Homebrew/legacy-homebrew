require 'formula'

class Rancid < Formula
  homepage 'http://www.shrubbery.net/rancid/'
  url 'ftp://ftp.shrubbery.net/pub/rancid/rancid-3.1.tar.gz'
  sha1 '5e5bdf84634c958ad4cd413c3e31c348340ebd05'

  bottle do
    sha1 "837224d076cccb23bc1d3891021e3e4fb9dfd791" => :yosemite
    sha1 "2b58d8cedb8e78e38259751374b8e047b62812b9" => :mavericks
    sha1 "e8eceee0e238a220231f4227e45ed25567212e4e" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--exec-prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/rancid", "-t", "cisco", "localhost"
  end
end
