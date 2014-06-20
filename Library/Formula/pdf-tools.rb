require "formula"

class PdfTools < Formula
  homepage "https://github.com/axot/pdf-tools"
  url "https://github.com/axot/pdf-tools/releases/download/v0.20/pdf-tools_v0.20.tgz"
  sha1 "0592f58d8f6dcdc597525ce887abda564eced285"

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
    ENV["zlib_CFLAGS"] = "-I/usr/include"
    ENV["zlib_LIBS"] = "-L/usr/lib -lz"

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"

    prefix.install "pdf-tools-0.20.tar"
    (prefix/"elpa").mkpath
    system "tar", "--strip-components=1", "-xf", "#{prefix}/pdf-tools-0.20.tar", "-C", "#{prefix}/elpa"
  end

  def caveats; <<-EOS.undent
    To install to your Emacs run:
      emacs -Q --batch --eval "(package-install-file \\"#{prefix}/pdf-tools-0.20.tar\\")"
    EOS
  end
end
