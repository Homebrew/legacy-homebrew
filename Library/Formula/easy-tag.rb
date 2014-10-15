require "formula"

class EasyTag < Formula
  homepage "http://projects.gnome.org/easytag"
  url "http://ftp.gnome.org/pub/GNOME/sources/easytag/2.2/easytag-2.2.4.tar.xz"
  sha256 "458329ab17e07fac5e92a2d732f0f4e9b12ea8aa31707506b39d3b2428d0c091"

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
