require 'formula'

class Hercules < Formula
  homepage 'http://www.hercules-390.eu/'
  url 'http://downloads.hercules-390.eu/hercules-3.09.tar.gz'
  sha1 '5cbe89ec214de00b90e3077c27db636a7d2607f5'

  skip_clean :la

  depends_on 'gawk'

  def install
    # Since Homebrew optimizes for us, tell Hercules not to.
    # (It gets it wrong anyway.)
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-optimization=no"
    # Reported upstream:
    # https://github.com/rbowler/spinhawk/issues/16
    inreplace "hscutl.c", "SOL_TCP", "IPPROTO_TCP"
    system "make"
    system "make install"
  end
end
