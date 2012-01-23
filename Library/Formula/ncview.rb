require 'formula'

class Ncview < Formula
  url 'ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.1.tar.gz'
  homepage 'http://meteora.ucsd.edu/~pierce/ncview_home_page.html'
  md5 '34e25f5949af342a1783542799f51bed'

  depends_on "netcdf"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--x-libraries=/usr/X11/lib",
                          "--x-includes=/usr/X11/include"
    system "make install"
  end
end
