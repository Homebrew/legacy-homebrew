require 'formula'

class Dotwrp < Formula
  homepage 'https://github.com/mcg1969/dotwrp'
  url 'https://github.com/mcg1969/dotwrp/archive/v1.2.tar.gz'
  sha1 'ec832b1ba160b6c5028af92bc77e725a6588b8bc'
  head 'https://github.com/mcg1969/dotwrp.git'
  def install
    system "#{ENV.cc} #{ENV.cflags} -c dotwrp.c"
    system "ar -cru libdotwrp.a dotwrp.o"
    system "ranlib libdotwrp.a"
    lib.install 'libdotwrp.a'
  end
end
