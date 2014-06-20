require "formula"

class Kakasi < Formula
  homepage "http://www.namazu.org/"
  url "http://kakasi.namazu.org/stable/kakasi-2.3.5.tar.gz"
  sha1 "a9deadc8f43ab9719f4efd3abfa877ae28e33269"

  bottle do
    sha1 "5356d339f9094598cb2ec7946059ef6badc3e804" => :mavericks
    sha1 "6c402155db7f87d2ab0f90f6daa56f521df3b0f5" => :mountain_lion
    sha1 "d084721f148f6de29a27c00dda8d3f49a55fb8ae" => :lion
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
