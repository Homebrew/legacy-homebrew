require 'formula'

class Libgsf < Formula
  homepage 'http://projects.gnome.org/gnumeric/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libgsf/1.14/libgsf-1.14.30.tar.xz'
  sha256 'cb48c3480be4a691963548e664308f497d93c9d7bc12cf6a68d5ebae930a5b70'

  bottle do
    revision 1
    sha1 "f48d8c6bd40eee7b9be7c64e7ea21cb76285fcf3" => :yosemite
    sha1 "b7a8a49fba4d6d872441bba5e75d6ece2d37167d" => :mavericks
    sha1 "c6b181013b45e099918d9b2a84d24c963ce914cb" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
