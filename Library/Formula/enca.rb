class Enca < Formula
  desc "Charset analyzer and converter"
  homepage "https://cihar.com/software/enca/"
  url "https://dl.cihar.com/enca/enca-1.16.tar.gz"
  sha256 "de63ce06b373964ee5fbb3fea8286876de03ee095b1a2e3b7d28a940a13aff6f"
  head "https://github.com/nijel/enca.git"

  bottle do
    sha256 "4d29d6d2bd8eb237c7c6cb11eced72275474407cdba4b6eb6d9a6b3e5eb42acf" => :el_capitan
    sha256 "54b011909780456df24c433a8ab64a011dbef7ead8bdca555fdff90636f1a510" => :yosemite
    sha256 "da6501ffead4ba7f0cb0d4197ee0c97116a33a36dbbcb246b0dd10b8ed8a26c9" => :mavericks
    sha256 "476ca610d42f1d8dec235ccbf14bd1bc8efe4b2f3280ddf3e30457734f0264de" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    enca = "#{bin}/enca --language=none"
    assert_match /ASCII/, `#{enca} <<< 'Testing...'`
    assert_match /UCS-2/, `#{enca} --convert-to=UTF-16 <<< 'Testing...' | #{enca}`
  end
end
