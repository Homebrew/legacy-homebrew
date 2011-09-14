require 'formula'

class BaculaFd < Formula
  url 'http://downloads.sourceforge.net/project/bacula/bacula/5.0.3/bacula-5.0.3.tar.gz'
  homepage 'http://www.bacula.org/'
  md5 '9de254ae39cab0587fdb2f5d8d90b03b'

  # Cleaning seems to break things:
  skip_clean :all

  def install

    # Force 32 bit build. Formula builds 64 bit binary without error
    # on Snow Leopard and Lion, but binary is non-functional.
    ENV.m32

    system "./configure", "--prefix=#{prefix}", "--sbindir=#{bin}",
                          "--with-working-dir=#{prefix}/working",
                          "--with-pid-dir=#{HOMEBREW_PREFIX}/var/run",
                          "--enable-client-only",
                          "--disable-conio", "--disable-readline"
    system "make"
    system "make install"

    # Ensure var/run exists:
    (var + 'run').mkpath

  end

end
