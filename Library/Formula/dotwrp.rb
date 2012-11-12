require 'formula'

class Dotwrp < Formula
  homepage 'https://github.com/tenomoto/dotwrp'
  url 'https://github.com/tenomoto/dotwrp/tarball/v1.0'
  sha1 '98d0d2ad0c49528e0df5d004962a25c5414b17b8'

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
