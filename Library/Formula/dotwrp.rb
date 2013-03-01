require 'formula'

class Dotwrp < Formula
  homepage 'https://github.com/tenomoto/dotwrp'
  url 'https://github.com/tenomoto/dotwrp/tarball/v1.1'
  sha1 '2f79f25f5d39443596f2a60520eeecb23902aa74'

  head 'https://github.com/tenomoto/dotwrp.git'

  def install
    ENV.fortran

    # note: fno-underscoring is vital to override the symbols in Accelerate
    system "#{ENV["FC"]} #{ENV["FFLAGS"]} -fno-underscoring -c dotwrp.f90"
    system "ar -cru libdotwrp.a dotwrp.o"
    system "ranlib libdotwrp.a"

    lib.install 'libdotwrp.a'
  end
end
