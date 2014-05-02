require 'formula'

class Hercules < Formula
  homepage 'http://www.hercules-390.eu/'
  url 'http://downloads.hercules-390.eu/hercules-3.10.tar.gz'
  sha1 '10599041c7e5607cf2e7ecc76802f785043e2830'

  skip_clean :la

  head do
    url 'https://github.com/hercules-390/hyperion.git'
    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  def install
    if build.head?
      ENV.append 'CFLAGS', '-D_FORTIFY_SOURCE=0' if MacOS.version >= :maverick

      # bundled autoconf.sh omits --add-missing
      system "aclocal -I m4 -I autoconf"
      system "autoheader"
      system "automake --add-missing"
      system "autoconf"

      # IPv6 doesn't build on OSX
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--disable-ipv6",
                            "--enable-optimization=no"
    else
      # Since Homebrew optimizes for us, tell Hercules not to.
      # (It gets it wrong anyway.)
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--enable-optimization=no"
    end

    system "make"
    system "make install"
  end
end
