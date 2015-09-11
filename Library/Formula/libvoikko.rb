class Libvoikko < Formula
  desc "Linguistic software for Finnish"
  homepage "http://voikko.puimula.org/"
  url "http://www.puimula.org/voikko-sources/libvoikko/libvoikko-3.8.tar.gz"
  sha256 "1df2f4a47217d1de5978e1586c1bbf61a1454cef6aadadbda6aec45738e69cff"

  bottle do
    cellar :any
    revision 1
    sha1 "11c152b2f716a8188e7bad9ff691e279ba72b810" => :yosemite
    sha1 "2a6e8102def1ca64b0582d93cbc7d47aed515818" => :mavericks
    sha1 "77ad5d81082c547a1cc1d93465eca0571cb4dcdf" => :mountain_lion
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
