class Soccerwindow2 < Formula
  desc "Tools for RoboCup Soccer Simulator"
  homepage "https://osdn.jp/projects/rctools/"
  url "http://dl.osdn.jp/rctools/51942/soccerwindow2-5.1.0.tar.gz"
  sha256 "3505f662144d5c97628191c941e84af4d384770733b9ff93ab8b58c2d1b9c22b"

  bottle do
    sha1 "211691f9c8e7e89c8451693065b2ce7b01fbb65f" => :mavericks
    sha1 "ffa56eb8ce4c37bb5f9725ed657733e1246dba22" => :mountain_lion
    sha1 "64dfa71965958b205ba50c439efc83d10f872535" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "qt"
  depends_on "boost"
  depends_on "librcsc"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/soccerwindow2 -v | grep 'soccerwindow2 Version #{version}'"
  end
end
