require 'formula'

class Bcwipe < Formula
  homepage 'http://www.jetico.com/linux/bcwipe-help/'
  url 'http://www.jetico.com/linux/BCWipe-1.9-8.tar.gz'
  md5 'b8ecc0a62856e7c752020bdfafc89c75'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # This does not get detected properly.
    # Should be reported upstream!
    inreplace "config.h", "/* #undef HAVE_GETTIMEOFDAY */", "#define HAVE_GETTIMEOFDAY 1"

    system "make", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", "install"
  end
end
