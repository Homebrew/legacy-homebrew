require 'formula'

class X3270 <Formula
  url 'http://sourceforge.net/projects/x3270/files/x3270/3.3.11ga6/suite3270-3.3.11ga6-src.tgz'
  homepage 'http://x3270.bgp.nu/'
  md5 '01d6d3809a457e6f6bd3731642e0c02d'
  version '3.3.11ga6'

  def install
  	system "rm -rf c3270-3.3; rm -rf pr3287-3.3; rm -rf s3270-3.3; rm -rf tcl3270-3.3; rm -rf wc3270-3.3; rm -rf wpr3287-3.3; rm -rf ws3270-3.3;"
    system "mv x3270-3.3/* .; rm -rf x3270-3.3/"
    system "./configure", 	"--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

