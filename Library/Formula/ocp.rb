class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "http://sourceforge.net/p/opencubicplayer/home/"
  url "https://downloads.sourceforge.net/project/opencubicplayer/ocp-0.1.21/ocp-0.1.21.tar.bz2"
  sha256 "d88eeaed42902813869911e888971ab5acd86a56d03df0821b376f2ce11230bf"

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
    system "make", "install"
  end
end
