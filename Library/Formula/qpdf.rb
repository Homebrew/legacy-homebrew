require "formula"

class Qpdf < Formula
  homepage "http://qpdf.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/qpdf/qpdf/5.1.2/qpdf-5.1.2.tar.gz"
  sha1 "ede3938fdf2e3bf603fce6eb2bd93b3a2e1d13b9"

  depends_on "pcre"

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{Formula["pcre"].opt_lib}"

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
