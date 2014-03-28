require 'formula'

class Atk < Formula
  homepage 'http://library.gnome.org/devel/atk/'
  url 'http://ftp.gnome.org/pub/gnome/sources/atk/2.12/atk-2.12.0.tar.xz'
  sha256 '48a8431974639c5a59c24fcd3ece1a19709872d5dfe78907524d9f5e9993f18f'

  bottle do
    sha1 "f2d6e44d20954bc11b0b031d95c2b8def08227ac" => :mavericks
    sha1 "a001261286b17f0c43fce8f1f267a3e19d133bc9" => :mountain_lion
    sha1 "30c7d64a0836a73d68ead846db528ab0479930d5" => :lion
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
