require "formula"

class Ocp < Formula
  homepage "http://sourceforge.net/p/opencubicplayer/home/"
  url "http://downloads.sourceforge.net/project/opencubicplayer/ocp-0.1.21/ocp-0.1.21.tar.bz2"
  sha1 "aaa16cf1979c572b09c73e7cc61350bfc4477380"

  depends_on "libvorbis"
  depends_on "mad" => :recommended
  depends_on "flac" => :recommended
  depends_on "adplug" => :optional

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --without-x11
      --without-sdl
      --without-desktop_file_install
    ]

    args << "--without-mad"  if build.without? "mad"
    args << "--without-flac" if build.without? "flac"
    args << "--with-adplug"  if build.with? "adplug"

    system "./configure", *args
    system "make"
    system "make install"
  end
end
