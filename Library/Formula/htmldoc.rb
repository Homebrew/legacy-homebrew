class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/projects.php?Z1"
  url "https://www.msweet.org/files/project1/htmldoc-1.8.29-source.tar.bz2"
  sha256 "e8c96ad740d19169eab8305c8e2ee1c795c4afa59ba99d18786ad191a2853f31"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d8e72ac7a319c7da641bc73f20eee84440d2eb06d7600a20e82df5ac37c1599" => :el_capitan
    sha256 "7aedc00491a57d4bd1a9c17872008408675e3dfac7c173279233c7d0a076f97f" => :yosemite
    sha256 "0b7ccf2314644a4deed69a92a717643862ec7951e949750c6ced4410d694f1e1" => :mavericks
  end

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
