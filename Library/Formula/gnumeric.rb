require 'formula'

class Gnumeric < Formula
  homepage 'http://projects.gnome.org/gnumeric/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gnumeric/1.10/gnumeric-1.10.17.tar.bz2'
  sha256 'bb2a13424811d132fe1be7a6e82d61157a18c630fc91b7409503dbd7ef600ea5'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'intltool'
  depends_on 'goffice'
  depends_on 'rarian'
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
