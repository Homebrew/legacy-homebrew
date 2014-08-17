require "formula"

class EasyTag < Formula
  homepage "http://projects.gnome.org/easytag"
  url "http://ftp.gnome.org/pub/GNOME/sources/easytag/2.2/easytag-2.2.2.tar.xz"
  sha1 "165a9288d0736abcd729e570687ddd3b44f578b3"

  depends_on :x11
  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "gtk+"
  depends_on "hicolor-icon-theme"
  depends_on "id3lib"
  depends_on "libid3tag"
  depends_on "taglib"

  depends_on "libvorbis" => :recommended
  depends_on "flac" => :recommended
  depends_on "libogg" if build.with? "flac"

  depends_on "speex" => :optional
  depends_on "wavpack" => :optional

  def install
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].lib}/python2.7/site-packages"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize # make install fails in parallel
    system "make install"
  end
end
