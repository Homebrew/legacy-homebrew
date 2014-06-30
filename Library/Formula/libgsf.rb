require 'formula'

class Libgsf < Formula
  homepage 'http://projects.gnome.org/gnumeric/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libgsf/1.14/libgsf-1.14.30.tar.xz'
  sha256 'cb48c3480be4a691963548e664308f497d93c9d7bc12cf6a68d5ebae930a5b70'

  bottle do
    sha1 "5bcdbd4365cf4304d8a1ae0230b8980f54eebe31" => :mavericks
    sha1 "0882a21c7ed87f6435c59564fa3a582f1c626223" => :mountain_lion
    sha1 "eb2f93e87fd8cfade15362547f2940d77ff7556f" => :lion
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
