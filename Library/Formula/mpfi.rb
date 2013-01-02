require 'formula'

class Mpfi < Formula
  homepage 'http://perso.ens-lyon.fr/nathalie.revol/software.html'
  url 'https://gforge.inria.fr/frs/download.php/30130/mpfi-1.5.1.tar.gz'
  sha1 '288302c0cdefe823cc3aa71de31c1da82eeb6ad0'

  depends_on 'gmp'
  depends_on 'mpfr'

  option '32-bit'

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]

    # Build 32-bit where appropriate, and help configure find 64-bit CPUs
    # Note: This logic should match what the GMP formula does.
    if MacOS.prefer_64_bit? and not build.include? '32-bit'
      ENV.m64
      args << '--build=x86_64-apple-darwin'
    else
      ENV.m32
      args << '--build=none-apple-darwin'
    end

    system './configure', *args
    system 'make'
    system 'make install'
  end
end
