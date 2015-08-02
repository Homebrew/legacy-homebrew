class Uim < Formula
  desc "Multilingual input method library"
  homepage "http://code.google.com/p/uim/"
  url "https://github.com/uim/uim/releases/download/uim-1.8.6/uim-1.8.6.tar.gz"
  sha256 "0eebcf5b2192d0cd11018adbd69e358bfa062d3b5d63c1dd0b73d5f63eb7afe7"

  depends_on :x11
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "intltool"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
