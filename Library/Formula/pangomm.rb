require 'formula'

class Pangomm < Formula
  homepage 'http://www.pango.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/pangomm/2.34/pangomm-2.34.0.tar.xz'
  sha256 '0e82bbff62f626692a00f3772d8b17169a1842b8cc54d5f2ddb1fec2cede9e41'

  bottle do
    sha1 "b13caa853cccac9178f1602c82ab47ac53ed1d56" => :mavericks
    sha1 "a6a2bd45d41390abbcfbaf7d8dcaef259a49b30d" => :mountain_lion
    sha1 "9fe4cb5a9e9f3ccea84c2b9ed4b59c5c4d6c06c0" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'pango'
  depends_on 'glibmm'
  depends_on 'cairomm'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
