require 'formula'

class Bcwipe < Formula
  url 'http://www.jetico.com/linux/BCWipe-1.9-8.tar.gz'
  homepage 'http://www.jetico.com/linux/bcwipe-help/'
  md5 'b8ecc0a62856e7c752020bdfafc89c75'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"

    # Remove bad arch flags
    inreplace 'Makefile' do |s|
      s.change_make_var! 'CFLAGS', ENV.cflags
      s.change_make_var! 'LDFLAGS', ENV.ldflags
    end

    # This does not get detected properly.
    # Should be reported upstream!
    inreplace "config.h", "/* #undef HAVE_GETTIMEOFDAY */", "#define HAVE_GETTIMEOFDAY 1"

    system "make install"
  end
end
