require 'formula'

class Dotwrp < Formula
  url 'https://github.com/tenomoto/dotwrp.git', :using => :git
  homepage 'https://github.com/tenomoto/dotwrp'
  version '1.0'

  def install
    ENV.fortran

    # note: fno-underscoring is vital to override the symbols in Accelerate
    system "#{ENV["FC"]} #{ENV["FFLAGS"]} -fno-underscoring -c dotwrp.f90"
    system "/usr/bin/ar -cru libdotwrp.a dotwrp.o"
    system "/usr/bin/ranlib libdotwrp.a"

    lib.install 'libdotwrp.a'
  end
end
