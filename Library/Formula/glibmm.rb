require 'formula'

class Glibmm < Formula
  homepage 'http://www.gtkmm.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/glibmm/2.38/glibmm-2.38.0.tar.xz'
  sha256 'f37bab6bedb7b68045e356feca9e27760a5ce50d95df07156656a0e1deabc402'

  depends_on 'xz' => :build
  depends_on 'pkg-config' => :build
  depends_on 'libsigc++'
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
