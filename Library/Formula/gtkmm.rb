require 'formula'

class Gtkmm < Formula
  homepage 'http://www.gtkmm.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gtkmm/2.24/gtkmm-2.24.4.tar.xz'
  sha256 '443a2ff3fcb42a915609f1779000390c640a6d7fd19ad8816e6161053696f5ee'

  bottle do
    revision 1
    sha1 "583ee4f8edf8226f60bf3434c16ad8f7e82d4736" => :yosemite
    sha1 "dcb4b15cf0fad1f14fc1dd82279dfd9d4d92fb56" => :mavericks
    sha1 "3b7a030bf1c5e0dbe86b6ad847d5ed141fb7b4ef" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'glibmm'
  depends_on 'gtk+'
  depends_on 'libsigc++'
  depends_on 'pangomm'
  depends_on 'atkmm'
  depends_on 'cairomm'
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
