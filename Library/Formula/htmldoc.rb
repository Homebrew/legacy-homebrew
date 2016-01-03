class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/projects.php?Z1"
  url "https://www.msweet.org/files/project1/htmldoc-1.8.29-source.tar.bz2"
  sha256 "e8c96ad740d19169eab8305c8e2ee1c795c4afa59ba99d18786ad191a2853f31"

  depends_on "libpng"
  depends_on "jpeg"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end
end
