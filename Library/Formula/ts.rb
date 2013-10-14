require 'formula'

class Ts < Formula
  homepage 'http://viric.name/soft/ts'
  url 'http://viric.name/soft/ts/ts-0.7.3.tar.gz'
  sha1 '33b9321d4f48a2c2685a8240db4e00c0e69ef9bc'

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

end
