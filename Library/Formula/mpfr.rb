require 'formula'

class Mpfr <Formula
  url 'http://www.mpfr.org/mpfr-3.0.0/mpfr-3.0.0.tar.bz2'
  homepage 'http://www.mpfr.org/'
  md5 'f45bac3584922c8004a10060ab1a8f9f'

  depends_on 'gmp'

  def options
    [["--32-bit", "Force 32-bit."]]
  end

  def patches
    {:p1 => ['http://www.mpfr.org/mpfr-3.0.0/allpatches']}
  end

  def install
    if Hardware.is_32_bit? or ARGV.include? "--32-bit"
      ENV.m32
      args << "--host=none-apple-darwin"
    else
      ENV.m64
    end

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
