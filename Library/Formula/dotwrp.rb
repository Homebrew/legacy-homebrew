require 'formula'

class Dotwrp < Formula
  homepage 'https://github.com/tenomoto/dotwrp'
  url 'https://github.com/tenomoto/dotwrp/tarball/v1.0'
  md5 '629f1f66fbb9837ee1e21a666a9688fa'

  head 'https://github.com/tenomoto/dotwrp.git'

  def install
    ENV.fortran

    # note: fno-underscoring is vital to override the symbols in Accelerate
    system "#{ENV["FC"]} #{ENV["FFLAGS"]} -fno-underscoring -c dotwrp.f90"
    system "/usr/bin/ar -cru libdotwrp.a dotwrp.o"
    system "/usr/bin/ranlib libdotwrp.a"

    lib.install 'libdotwrp.a'
  end
end
