class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://sourceforge.net/projects/opencubicplayer/"
  url "https://downloads.sourceforge.net/project/opencubicplayer/ocp-0.1.21/ocp-0.1.21.tar.bz2"
  sha256 "d88eeaed42902813869911e888971ab5acd86a56d03df0821b376f2ce11230bf"

  bottle do
    sha256 "4bd576f3d75594928348d30b3b3436cdeebba844be8a8ba65251eb1731de437e" => :el_capitan
    sha256 "e6b941f5aa2508a9628487cf40a186188f1dbf986a9a5ab2a824c57a03d45055" => :yosemite
    sha256 "d2a095ce47bdea35fad3f6f7ffac500ccc4dc8dd149a9c1dbbae2bbf92809886" => :mavericks
  end

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
