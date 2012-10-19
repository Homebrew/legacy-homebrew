require "formula"

class Ocp < Formula
  homepage "http://sourceforge.net/p/opencubicplayer/home/"
  url "http://downloads.sourceforge.net/project/opencubicplayer/ocp-0.1.21/ocp-0.1.21.tar.bz2"
  sha1 "aaa16cf1979c572b09c73e7cc61350bfc4477380"

  option "without-mad", "disable mad mpeg audio support"
  option "without-flac", "disable FLAC support"
  option "with-adplug", "enable adplug support"

  depends_on "libvorbis"
  depends_on "mad" => :recommended unless build.include? "without-mad"
  depends_on "flac" => :recommended unless build.include? "without-flac"
  depends_on "adplug" => :optional if build.include? "with-adplug"

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --without-x11
      --without-sdl
      --without-desktop_file_install
    ]

    args << "--without-mad"  if build.include? "without-mad"
    args << "--without-flac" if build.include? "without-flac"
    args << "--with-adplug"  if build.include? "with-adplug"

    system "./configure", *args
    system "make"
    system "make install"
  end
end
