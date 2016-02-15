class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/projects.php?Z1"
  url "https://www.msweet.org/files/project1/htmldoc-1.8.29-source.tar.bz2"
  sha256 "e8c96ad740d19169eab8305c8e2ee1c795c4afa59ba99d18786ad191a2853f31"
  revision 1

  bottle do
    sha256 "a8e329e977d7bd0f6a366e2109634d527d8953473515d0993072576fbab78a73" => :el_capitan
    sha256 "2b4d0403a450e761fcb833ccd6f7af9fcdef5de4f24bbaa13abfa449e965b196" => :yosemite
    sha256 "9afb3cda57a75cce5e631dbbe5df6dad8dfef4aa07837a1c0bbb1e4d4fc3d0c1" => :mavericks
  end

  depends_on "libpng"
  depends_on "jpeg"

  def install
    system "./configure", "--disable-debug",
                          "--disable-ssl",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end
end
