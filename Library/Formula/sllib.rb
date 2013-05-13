require 'formula'

class Sllib < Formula
  homepage ''
  url "http://www.ir.isas.jaxa.jp/~cyamauch/sli/sllib-1.4.2.tar.gz"
  homepage 'http://www.ir.isas.jaxa.jp/~cyamauch/sli/index.html'
  sha1 'b55522796ac43fa6f9c8341fc54367f1cf334a28'

  def install
    system "/bin/sh ./configure --prefix=#{prefix}"
  system "make -j4"
    system "make install"
  end

  def test
    if(!File.exist?("#{bin}/s++"))then
      puts "==> Executable s++ was not successfully installed."
      return false
    else
      puts "==> Executable s++ is found."
    end
    if(!File.exist?("#{lib}/libsllib.a"))then
      puts "==> Library libsllib.a was not successfully installed."
      return false
    else
      puts "==> Library libsllib.a is found."
    end
    if(!File.exist?("#{include}/sli/asarray.h") or !File.exist?("#{include}/sli/xmlparser.h"))then
      puts "==> Header files were not successfully installed."
      return false
    else
      puts "==> Header files were found."
    end
    puts "It seems that sllib was successfully installed!"
    return true
  end
end
