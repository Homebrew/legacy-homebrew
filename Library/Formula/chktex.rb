class Chktex < Formula
  homepage "http://baruch.ev-en.org/proj/chktex/"
  url "http://download.savannah.gnu.org/releases/chktex/chktex-1.7.4.tar.gz"
  version "1.7.4"
  sha256 "77ed995eabe7088dacf53761933da23e6bf8be14d461f364bd06e090978bf6d2"

  def install
    ENV.append_path "PATH", "/Library/TeX/texbin"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  def caveats
    """
    This formula assumes you have LaTeX binaries already installed under /Library/TeX/texbin
    """
  end
end
