require 'formula'

class Sfitsio < Formula
  homepage ''
  url "http://www.ir.isas.jaxa.jp/~cyamauch/sli/sfitsio-1.4.2.tar.gz"
  homepage 'http://www.ir.isas.jaxa.jp/~cyamauch/sli/index.html#SFITSIO'
  sha1 '916db23bca3848118b268faa1ed756742aef4746'

  depends_on 'sllib'

  def install
    system "sh ./configure --prefix=#{prefix}"
    system "make -j4"
    system "make install"
  end

  def test
    if(!File.exist?("#{lib}/libsfitsio.a"))then
      puts "==> Library libsfitsio.a was not successfully installed."
      return false
    else
      puts "==> Library libsfitsio.a is found."
    end
    if(!File.exist?("#{include}/sli/fits.h") or !File.exist?("#{include}/sli/fitscc.h"))then
      puts "==> Header files were not successfully installed."
      return false
    else
      puts "==> Header files were found."
    end
    puts "It seems that sfitsio was successfully installed!"
    return true
  end
end
