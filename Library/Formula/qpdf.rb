class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "http://qpdf.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/qpdf/qpdf/5.1.3/qpdf-5.1.3.tar.gz"
  sha256 "d5164bdad3afc381568dbe8e1509a4a6a911d4d077f1fc20b9866ef8fad901d3"

  bottle do
    sha256 "28e4e0e21d2de2e45dfb38afb53968f840b01480459590b2026c1c63803d5226" => :yosemite
    sha256 "6439a662091505b0ba31e0f5c95a676ce934c758ea00284006b092b954a3955b" => :mavericks
    sha256 "424d315f98dd4276884b66b3135fc04ee394a3235ae17cf65d4c596aa61f2506" => :mountain_lion
  end

  depends_on "pcre"

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{Formula["pcre"].opt_lib}"

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
