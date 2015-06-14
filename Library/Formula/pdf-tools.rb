class PdfTools < Formula
  desc "Emacs support library for PDF files"
  homepage "https://github.com/politza/pdf-tools"
  url "https://github.com/politza/pdf-tools/archive/v0.50.tar.gz"
  sha256 "3a9a17eb51d78d1366381aa3e2224051d5e1668ea91b59a76bb6711428093cc6"

  bottle do
    sha256 "66cdc0c25a73a20e34fe3da69a0b3215cb01c6d8e3a8b54be84fc611a21eb1ea" => :yosemite
    sha256 "309d7f940d2bc3b08003435fbc2251bfcfce7cf2204fa61590e66cf69234985a" => :mavericks
    sha256 "db1601cb97a5490fa24fb02a8eeaa8bb0f7de3cb8d7db52fec5fc5d807a4ba34" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "cairo"
  depends_on "poppler"

  def install
    system "make"

    prefix.install "pdf-tools-0.50.tar"
    (prefix/"elpa").mkpath
    system "tar", "--strip-components=1", "-xf", "#{prefix}/pdf-tools-0.50.tar", "-C", "#{prefix}/elpa"
  end

  def caveats; <<-EOS.undent
    To install to your Emacs run:
      emacs -Q --batch --eval "(package-install-file \\"#{prefix}/pdf-tools-0.50.tar\\")"
    EOS
  end
end
