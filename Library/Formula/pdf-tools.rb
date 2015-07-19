class PdfTools < Formula
  desc "Emacs support library for PDF files"
  homepage "https://github.com/politza/pdf-tools"
  url "https://github.com/politza/pdf-tools/archive/v0.60.tar.gz"
  sha256 "3deff1183d69e942a9b9d94897e7aab73550574f953823815f5df925852d13f9"

  bottle do
    sha256 "0f43f1670b7d6fb1e068fbfcca30a4aa003e69a23a46ca40458ec13002682b64" => :yosemite
    sha256 "39a5f5308187cb470142858fb5139882af8860fa56fdbda5640dc6cbc33a6277" => :mavericks
    sha256 "c8aeb9f41a2a70c28b37460c9c27a53fae6bca69086dcfd323522c5ab7d709a1" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "cairo"
  depends_on "poppler"

  def install
    system "make"

    prefix.install "pdf-tools-#{version}.tar"
    (prefix/"elpa").mkpath
    system "tar", "--strip-components=1", "-xf", "#{prefix}/pdf-tools-#{version}.tar", "-C", "#{prefix}/elpa"
  end

  def caveats; <<-EOS.undent
    To install to your Emacs run:
      emacs -Q --batch --eval "(package-install-file \\"#{prefix}/pdf-tools-#{version}.tar\\")"
    EOS
  end
end
