require 'formula'

class BaculaFd < Formula
  url 'http://downloads.sourceforge.net/project/bacula/bacula/5.2.13/bacula-5.2.13.tar.gz'
  homepage 'http://www.bacula.org/'
  sha1 '30b1eb2efb515138807163d046f675eaa29fad1c'

  def install
    # Configure Bacula
    #
    # * sets --disable-conio in order to force the use of readline
    #   (conio support not tested)
    # * working directory in /var/lib/bacula, reasonable place that
    #   matches Debian's location.
    system "./configure", "--prefix=#{prefix}", "--sbindir=#{bin}",
                          "--with-working-dir=#{var}/lib/bacula",
                          "--with-pid-dir=#{HOMEBREW_PREFIX}/var/run",
                          "--enable-client-only",
                          "--disable-conio"
    system "make"
    system "make install"

    # Ensure var/run exists:
    (var + 'run').mkpath

    # Create the working directory:
    (var + 'lib/bacula').mkpath
  end

end
