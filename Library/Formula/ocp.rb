require "formula"

class Ocp < Formula
  head "git://git.code.sf.net/p/opencubicplayer/code", :using => :git
  homepage "http://sourceforge.net/p/opencubicplayer/home/"

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
    args = ["--prefix=#{prefix}",
            "--disable-debug",
            "--disable-dependency-tracking",
            "--without-x11"]

    if ARGV.include? "--without-mad"
      args << "--without-mad"
    elsif ARGV.include? "--without-flac"
      args << "--without-flac"
    elsif ARGV.include? "--with-adplug"
      args << "--with-adplug"
    end

    system "./configure", *args
    system "make"
    system "make install"
  end

end
