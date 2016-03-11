class Aespipe < Formula
  desc "AES encryption or decryption for pipes"
  homepage "http://loop-aes.sourceforge.net/"
  url "http://loop-aes.sourceforge.net/aespipe/aespipe-v2.4d.tar.bz2"
  sha256 "c5ce656e0ade49b93e1163ec7b35450721d5743d8d804ad3a9e39add0389e50f"

  bottle do
    cellar :any_skip_relocation
    sha256 "64ee9d5b5abca294191d2b9cfb923c5213cd4c1967fc53383edb651c217a461c" => :el_capitan
    sha256 "9b6d98e9fad116799c96d5f423d7e12504d75b7e8c2d23ade617267cde47c89b" => :yosemite
    sha256 "68cab23444ced7d4087ed8a0892127956328cebaebc66009344e4bddf0ae3857" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"secret").write "thisismysecrethomebrewdonttellitplease"
    msg = "Hello this is Homebrew"
    encrypted = pipe_output("#{bin}/aespipe -P secret", msg)
    decrypted = pipe_output("#{bin}/aespipe -P secret -d", encrypted)
    assert_equal msg, decrypted.gsub(/\x0+$/, "")
  end
end
