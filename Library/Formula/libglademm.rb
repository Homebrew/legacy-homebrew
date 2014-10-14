require 'formula'

class Libglademm < Formula
  homepage 'http://gnome.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libglademm/2.6/libglademm-2.6.7.tar.bz2'
  sha1 'd7c0138c80ea337d2e9ae55f74a6953ce2eb9f5d'

  bottle do
    cellar :any
    sha1 "5b84255676239202a2f6f1223f78044424a9a16f" => :mavericks
    sha1 "513f15414a23dcf70f9e662b10ab6483139858bd" => :mountain_lion
    sha1 "908256dc2bba24e8de92e3420b6bbabcc3ea1451" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'gtkmm'
  depends_on 'libglade'
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
