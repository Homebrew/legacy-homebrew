require 'formula'

class Atk < Formula
  homepage 'http://library.gnome.org/devel/atk/'
  url 'http://ftp.gnome.org/pub/gnome/sources/atk/2.12/atk-2.12.0.tar.xz'
  sha256 '48a8431974639c5a59c24fcd3ece1a19709872d5dfe78907524d9f5e9993f18f'

  bottle do
    sha1 "dcb833f1676a66c2f747a3f32437b915e9e978b7" => :mavericks
    sha1 "629b4f16a103a3e4e55b6b22be8e5c01984f9f6b" => :mountain_lion
    sha1 "1a951bd1902b8fb12f6043664a1e15f89363e220" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gobject-introspection'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes"
    system "make"
    system "make install"
  end
end
