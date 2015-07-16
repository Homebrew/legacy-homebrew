class Gcal < Formula
  desc "Gcal is a program for calculating and printing calendars"
  homepage "https://www.gnu.org/software/gcal/"
  url "http://ftpmirror.gnu.org/gcal/gcal-3.6.3.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcal/gcal-3.6.3.tar.xz"
  sha256 "6742913a1d011ac109ad713ef4a8263eaf4c5cfd315471626a92f094e3e4b31b"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    date = shell_output("date +%Y")
    assert_match date, shell_output("#{bin}/gcal")
  end
end
