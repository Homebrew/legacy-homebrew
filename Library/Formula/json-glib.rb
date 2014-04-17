require 'formula'

class JsonGlib < Formula
  homepage 'http://live.gnome.org/JsonGlib'
  url 'http://ftp.gnome.org/pub/gnome/sources/json-glib/1.0/json-glib-1.0.0.tar.xz'
  sha256 'dbf558d2da989ab84a27e4e13daa51ceaa97eb959c2c2f80976c9322a8f4cdde'

  bottle do
    sha1 "0752cfa2f78c6be59db8eacfd52a46cec2191078" => :mavericks
    sha1 "ea3723bb024664c0e102a10dd03c16de00d43a4c" => :mountain_lion
    sha1 "90182a996bba98f1ad2b1487c8b1dc3936c17f26" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
