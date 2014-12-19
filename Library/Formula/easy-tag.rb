require "formula"

class EasyTag < Formula
  homepage "http://projects.gnome.org/easytag"
  url "http://ftp.gnome.org/pub/GNOME/sources/easytag/2.2/easytag-2.2.5.tar.xz"
  sha256 "a6da3a094997fa225d1c01211b282f2d3c2dfd93a74f3bec24017bd5a13f3855"

  bottle do
    sha1 "a7f3903c91ea6e7884a238f5a93cc46dd9da6fcd" => :yosemite
    sha1 "284cd60570c14b70dce6c670ba4d496399dc1c41" => :mavericks
    sha1 "efb11e24318b92bd002b21ef78c62f796c0dbeba" => :mountain_lion
  end

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
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize # make install fails in parallel
    system "make install"
  end
end
