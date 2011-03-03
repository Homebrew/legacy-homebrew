require 'formula'

class Szl <Formula
  url 'http://szl.googlecode.com/files/szl-1.0.tar.gz'
  homepage 'http://code.google.com/p/szl/'
  md5 'd25f73b2adf4b92229d8b451685506d1'

  depends_on 'binutils' # For objdump
  depends_on 'icu4c'
  depends_on 'protobuf' # for protoc

  def install
    ENV['OBJDUMP'] = "#{HOMEBREW_PREFIX}/bin/gobjdump"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
