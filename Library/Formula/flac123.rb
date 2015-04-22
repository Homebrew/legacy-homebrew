class Flac123 < Formula
  desc "Command-line program for playing FLAC audio files"
  homepage "http://flac-tools.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/flac-tools/flac123/flac123-0.0.12-release.tar.gz"
  sha256 "1976efd54a918eadd3cb10b34c77cee009e21ae56274148afa01edf32654e47d"

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  depends_on "flac"
  depends_on "libao"
  depends_on "libogg"
  depends_on "popt"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "CC=#{ENV.cc}",
                   # specify aclocal and automake without version suffixes
                   "ACLOCAL=${SHELL} #{buildpath}/missing --run aclocal",
                   "AUTOMAKE=${SHELL} #{buildpath}/missing --run automake"
  end

  test do
    system "#{bin}/flac123"
  end
end
