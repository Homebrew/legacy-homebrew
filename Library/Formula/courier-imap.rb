require 'formula'

class CourierImap < Formula
  homepage 'http://www.courier-mta.org/'
  url 'http://downloads.sourceforge.net/project/courier/imap/4.11.0/courier-imap-4.11.0.tar.bz2'
  md5 '6aa9a3487e1c255d1826833af362d1f7'

  depends_on 'courier-authlib'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    system "make install-configure"
  end

end
