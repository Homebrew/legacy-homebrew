require 'formula'

class CourierAuthlib < Formula
  homepage 'http://www.courier-mta.org/'
  url 'http://downloads.sourceforge.net/project/courier/authlib/0.65.0/courier-authlib-0.65.0.tar.bz2'
  md5 'e9287e33b0e70ea3745517b4d719948d'

  depends_on 'libtool'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
	    		  "--without-authmysql",
                          "--prefix=#{prefix}"
    system "make install"
    system "make install-configure"
  end

end
