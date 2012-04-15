require 'formula'

class Mpfi < Formula
  homepage 'http://perso.ens-lyon.fr/nathalie.revol/software.html'
  url 'https://gforge.inria.fr/frs/download.php/30130/mpfi-1.5.1.tar.gz'
  md5 '2787d2fab9ba7fc5b171758e84892fb5'

  depends_on 'gmp'
  depends_on 'mpfr'

  def options
    [["--32-bit", "Build 32-bit only."]]
  end

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]

    # Build 32-bit where appropriate, and help configure find 64-bit CPUs
    # Note: This logic should match what the GMP formula does.
    if MacOS.prefer_64_bit? and not ARGV.build_32_bit?
      ENV.m64
      args << "--build=x86_64-apple-darwin"
    else
      ENV.m32
      args << "--build=none-apple-darwin"
    end

    system "./configure", *args
    system "make"
    system "make install"
  end

end
