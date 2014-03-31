require "formula"

class PdfTools < Formula
  homepage "https://github.com/axot/pdf-tools"
  url "https://github.com/axot/pdf-tools/releases/download/v0.20/pdf-tools_v0.20.tgz"
  sha1 "0592f58d8f6dcdc597525ce887abda564eced285"

  depends_on "pkg-config" => :build

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool

  depends_on "cairo"
  depends_on "poppler" => "with-glib"

  def install
    ENV['zlib_CFLAGS'] = '-I/usr/include'
    ENV['zlib_LIBS'] = '-L/usr/lib -lz'

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
