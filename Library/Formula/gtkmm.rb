require 'formula'

class Gtkmm < Formula
  homepage 'http://www.gtkmm.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gtkmm/2.24/gtkmm-2.24.4.tar.xz'
  sha256 '443a2ff3fcb42a915609f1779000390c640a6d7fd19ad8816e6161053696f5ee'

  bottle do
    sha1 "12abc3e448a6419e147fa394388f9bace5151fb3" => :mavericks
    sha1 "418cbdad18035d6ed5ca13ad580017c5ed05f901" => :mountain_lion
    sha1 "4cc024301f11dd741da9c229ec7e083dcd92613a" => :lion
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
