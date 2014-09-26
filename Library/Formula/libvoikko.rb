require "formula"

class Libvoikko < Formula
  homepage "http://voikko.puimula.org/"
  url "http://www.puimula.org/voikko-sources/libvoikko/libvoikko-3.7.1.tar.gz"
  sha1 "b6d7ec669bbc33ba5f526f53b1d297f9ee315178"

  bottle do
    cellar :any
    sha1 "db25afc7130491bbf3e5097c04a0eca8d7a2915d" => :mavericks
    sha1 "0663d391a2962d6245a89e17afd2a45b7c4a5460" => :mountain_lion
    sha1 "2fa799be5ce26948edc2c5c4c7e74c181aee9dc6" => :lion
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
