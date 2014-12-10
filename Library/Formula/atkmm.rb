require 'formula'

class Atkmm < Formula
  homepage 'http://www.gtkmm.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/atkmm/2.22/atkmm-2.22.7.tar.xz'
  sha256 'bfbf846b409b4c5eb3a52fa32a13d86936021969406b3dcafd4dd05abd70f91b'

  bottle do
    sha1 "6c47047d111b4b950e1cb15425365b13b11f6a1b" => :mavericks
    sha1 "2262b36b562f9f2ea1c024923e738a08145e97df" => :mountain_lion
    sha1 "eb053cdcba6fc56e0bddde08ac356a18d9bf53b0" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'atk'
  depends_on 'glibmm'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
