require "formula"

class Rcssmonitor < Formula
  homepage "http://sserver.sourceforge.net/"
  url "https://downloads.sourceforge.net/sserver/rcssmonitor/15.1.0/rcssmonitor-15.1.0.tar.gz"
  sha1 "9a2c1905429882291267b463ec1db858ab0dde90"

  bottle do
    sha1 "07ae3bf0142c044c374f2366458388aa1c3a483f" => :mavericks
    sha1 "c87a3380c6390b7d75126d777d03dbf83055d9f7" => :mountain_lion
    sha1 "a03085dccc0377736de773ff39915db61a9a4dfd" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "qt"
  depends_on "boost"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rcssmonitor --version | tail -1 | grep 'rcssmonitor Version #{version}'"
  end
end
