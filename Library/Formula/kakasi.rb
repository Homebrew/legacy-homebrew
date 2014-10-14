require "formula"

class Kakasi < Formula
  homepage "http://www.namazu.org/"
  url "http://kakasi.namazu.org/stable/kakasi-2.3.6.tar.gz"
  sha1 "5f2e02264dda11940fb7b5387c327d4c4324bdb3"

  bottle do
    sha1 "8deab85f96629c49900ae301aeacaed1a4f8891f" => :mavericks
    sha1 "a116a8ecbf84ad1a5955b134f2f2f8ff05319660" => :mountain_lion
    sha1 "d8245a504319b627cc2c28cc0f012f7f2a898732" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    hiragana = `echo '\xa4\xa2 \xa4\xab \xa4\xb5'`.chomp
    romanji = `echo '#{hiragana}' | kakasi -rh -ieuc -Ha`.chomp
    assert_equal "a ka sa", romanji
  end
end
