require "formula"

class Ocp < Formula
  url "http://downloads.sourceforge.net/project/opencubicplayer/ocp-0.1.21/ocp-0.1.21.tar.bz2"
  sha1 'aaa16cf1979c572b09c73e7cc61350bfc4477380'
  homepage "http://sourceforge.net/p/opencubicplayer/home/"

  depends_on "libvorbis"
  depends_on "mad" unless ARGV.include? "--without-mad"
  depends_on "flac" unless ARGV.include? "--without-flac"
  depends_on "adplug" if ARGV.include? "--with-adplug"

  def options
    [
      ["--without-mad", "disable mad mpeg audio support"],
      ["--without-flac", "disable FLAC support"],
      ["--with-adplug", "enable adplug support"],
    ]
  end

  def install
    ENV.deparallelize

    args = ["--prefix=#{prefix}",
            "--without-x11",
            "--without-sdl",
            "--without-desktop_file_install"]

    args << "--without-mad"  if ARGV.include? "--without-mad"
    args << "--without-flac" if ARGV.include? "--without-flac"
    args << "--with-adplug"  if ARGV.include? "--with-adplug"

    system "./configure", *args
    system "make"
    system "make install"
  end
end
