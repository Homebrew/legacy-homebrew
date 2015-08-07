class Libntlm < Formula
  desc "Implements Microsoft's NTLM authentication"
  homepage "http://www.nongnu.org/libntlm/"
  url "http://www.nongnu.org/libntlm/releases/libntlm-1.4.tar.gz"
  sha256 "8415d75e31d3135dc7062787eaf4119b984d50f86f0d004b964cdc18a3182589"

  bottle do
    cellar :any
    revision 1
    sha1 "7c5f98bf311289a1aa49c08a5d2fa23ffb3fcc30" => :yosemite
    sha1 "550250645169374bf9275ff3e8c8f805560f3416" => :mavericks
    sha1 "a417f1bd4b1403094dddc8406d1f390832dabf53" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
