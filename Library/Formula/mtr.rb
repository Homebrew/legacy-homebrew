require 'formula'

class Mtr <Formula
  url 'ftp://ftp.bitwizard.nl/mtr/mtr-0.80.tar.gz'
  homepage 'http://www.bitwizard.nl/mtr/'
  md5 'fa68528eaec1757f52bacf9fea8c68a9'

  def install
    # We need to add this because nameserver8_compat.h has been removed in Snow Leopard
    ENV['LIBS'] = "-lresolv"
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end

  def caveats
    "Run mtr sudo'd in order to avoid the error: `unable to get raw sockets'"
  end
end
