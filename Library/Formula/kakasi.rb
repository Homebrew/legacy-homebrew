require "formula"

class Kakasi < Formula
  homepage "http://www.namazu.org/"
  url "http://kakasi.namazu.org/stable/kakasi-2.3.5.tar.gz"
  sha1 "a9deadc8f43ab9719f4efd3abfa877ae28e33269"

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
