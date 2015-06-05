require "formula"

class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "http://qpdf.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/qpdf/qpdf/5.1.3/qpdf-5.1.3.tar.gz"
  sha256 "d5164bdad3afc381568dbe8e1509a4a6a911d4d077f1fc20b9866ef8fad901d3"

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
