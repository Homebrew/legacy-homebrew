require 'brewkit'

class Mtr <Formula
  @url='ftp://ftp.bitwizard.nl/mtr/mtr-0.75.tar.gz'
  @homepage='http://www.bitwizard.nl/mtr/'
  @md5='23baca52d0922c2ecba7eba05317868c'

  def install
    # We need to add this because nameserver8_compat.h has been removed in Snow Leopard
    ENV['LIBS']= "-lresolv"
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
    bin.install "mtr"
  end
end
