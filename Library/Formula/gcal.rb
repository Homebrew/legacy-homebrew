class Gcal < Formula
  desc "Gcal is a program for calculating and printing calendars"
  homepage "https://www.gnu.org/software/gcal/"
  url "http://ftpmirror.gnu.org/gcal/gcal-3.6.3.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcal/gcal-3.6.3.tar.xz"
  sha256 "6742913a1d011ac109ad713ef4a8263eaf4c5cfd315471626a92f094e3e4b31b"

  bottle do
    cellar :any
    sha256 "2298293a8e7a4ee03bc66d072e29d6e5b64d2f2ff40527bf5d6cb5cbcaf8d03b" => :yosemite
    sha256 "7080b2c3ab5e8f71a9ad76e42be2c6725c3178f0ccdcb849f1df7b2e557fd55c" => :mavericks
    sha256 "831f243692973ba051631f48001f5ddc2cee42302929f605e4e245f5b0e4031a" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    date = shell_output("date +%Y")
    assert_match date, shell_output("#{bin}/gcal")
  end
end
