require 'formula'

class Scalpel < Formula
  url 'http://www.digitalforensicssolutions.com/Scalpel/scalpel-2.0.tar.gz'
  homepage 'http://www.digitalforensicssolutions.com/Scalpel/'
  md5 'b0da813bf34941e79209d7fafe86a6e6'
  depends_on 'tre'


  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    etc.install "scalpel.conf" => "scalpel.conf.sample"
  end

end
