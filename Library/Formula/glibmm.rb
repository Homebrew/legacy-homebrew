require 'formula'

class Glibmm < Formula
  homepage 'http://www.gtkmm.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/glibmm/2.38/glibmm-2.38.0.tar.xz'
  sha256 'f37bab6bedb7b68045e356feca9e27760a5ce50d95df07156656a0e1deabc402'

  depends_on 'xz' => :build
  depends_on 'pkg-config' => :build
  depends_on 'libsigc++'
  depends_on 'glib'

  depends_on 'automake' => :build
  depends_on 'autoconf' => :build
  depends_on 'libtool' => :build
  depends_on 'mm-common' => :build

  # Upstream patch to fix build error
  # Remove patch, autotools deps and call to autogen.sh at next version
  def patches
    "https://git.gnome.org/browse/glibmm/patch/?id=c619be2fadae1b5a87151db0b0adddf55584084a"
  end

  def install
    system "./autogen.sh", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
