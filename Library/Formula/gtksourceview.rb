require 'formula'

class Gtksourceview < Formula
  homepage 'http://projects.gnome.org/gtksourceview/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gtksourceview/2.10/gtksourceview-2.10.5.tar.gz'
  sha1 '1bb784d1e9d9966232928cf91b1ded20e8339670'

  bottle do
    sha1 "e776f4b2aa5a68f193d1f22352582cb923090614" => :yosemite
    sha1 "d6e3dd382f238451ad531475b7737a7d5c5f7b2d" => :mavericks
    sha1 "466836536733808dfbbe8c874b02b3e9afa84006" => :mountain_lion
  end

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'gtk+'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
