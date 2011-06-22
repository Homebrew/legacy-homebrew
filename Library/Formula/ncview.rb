require 'formula'

class Ncview < Formula
  url 'ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.0beta4.tar.gz'
  homepage 'http://meteora.ucsd.edu/~pierce/ncview_home_page.html'
  md5 '03968a8fdf13c71c7582c2352f771a85'
  version '2.0beta4'

  depends_on "netcdf"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--x-libraries=/usr/X11/lib",
                          "--x-includes=/usr/X11/include"
    system "make install"
  end
end
