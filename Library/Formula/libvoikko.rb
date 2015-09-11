class Libvoikko < Formula
  desc "Linguistic software for Finnish"
  homepage "http://voikko.puimula.org/"
  url "http://www.puimula.org/voikko-sources/libvoikko/libvoikko-3.8.tar.gz"
  sha256 "1df2f4a47217d1de5978e1586c1bbf61a1454cef6aadadbda6aec45738e69cff"

  bottle do
    cellar :any
    sha256 "c4488efa1bc718a9c56e3b3a98f3606810c70c999942dbaf8f7ab06005bd152e" => :yosemite
    sha256 "c8ad1b1671f4689dd0758a77a65e5a6e208fe77392d971695bab8d7ed0e27313" => :mavericks
    sha256 "e86477889e8ff1ffe9b1f60de5506e911cb584be674b6adaf5dffc58cc1c50d5" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "suomi-malaga-voikko"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-dictionary-path=#{HOMEBREW_PREFIX}/lib/voikko"
    system "make", "install"
  end
end
