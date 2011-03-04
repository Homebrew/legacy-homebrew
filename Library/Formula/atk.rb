require 'formula'

class Atk <Formula
  url 'ftp://ftp.gnome.org/pub/gnome/sources/atk/1.30/atk-1.30.0.tar.bz2'
  homepage 'http://library.gnome.org/devel/atk/'
  sha256 '92b9b1213cafc68fe9c3806273b968c26423237d7b1f631dd83dc5270b8c268c'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-glibtest"
    system "make install"
  end
end
