class Kakasi < Formula
  desc "Convert Kanji characters to Hiragana, Katakana, or Romaji"
  homepage "http://kakasi.namazu.org/"
  url "http://kakasi.namazu.org/stable/kakasi-2.3.6.tar.gz"
  sha256 "004276fd5619c003f514822d82d14ae83cd45fb9338e0cb56a44974b44961893"

  bottle do
    revision 1
    sha256 "da407c10d807cf72679df6555d29b53f388dd32abf674f1ae0ecbace44fc3372" => :yosemite
    sha256 "86403b2e2a45e2ea81b78bbe7edc7bf2b01d464f351ea265441413e63bf85822" => :mavericks
    sha256 "7c4bb01289baeee60544acf6fd81e9b0f5522428938ac9cd5b6ed2b3bc6619bf" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    hiragana = "\xa4\xa2 \xa4\xab \xa4\xb5"
    romanji = pipe_output("kakasi -rh -ieuc -Ha", hiragana).chomp
    assert_equal "a ka sa", romanji
  end
end
