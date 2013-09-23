require 'formula'

class Ejdb < Formula
  homepage 'http://ejdb.org/'
  url 'https://github.com/Softmotions/ejdb/archive/v1.1.24.tar.gz'
  sha1 'b743aef55a39a64bd4ee0e94fa58e2c90e63db02'

  def install
    cd 'tcejdb' do
      system "./configure", "--prefix=#{prefix}", "--disable-debug"
      system "make"
      system "make install"
    end
  end
end
