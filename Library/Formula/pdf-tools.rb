class PdfTools < Formula
  homepage "https://github.com/politza/pdf-tools"
  url "https://github.com/politza/pdf-tools/archive/v0.50.tar.gz"
  sha1 "200562d7ff9ffc79583ca370f0b8a42391e11a5d"

  bottle do
    sha1 "424085396d9c3669957be227e3347595fa620b64" => :mavericks
    sha1 "12acd5174bc22ccaa8d13359a5cdcaee344d83b5" => :mountain_lion
    sha1 "9275fd218bdc416b140214adb419d8f8201a491f" => :lion
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
