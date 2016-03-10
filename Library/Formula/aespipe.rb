class Aespipe < Formula
  desc "AES encryption or decryption for pipes"
  homepage "http://loop-aes.sourceforge.net/"
  url "http://loop-aes.sourceforge.net/aespipe/aespipe-v2.4d.tar.bz2"
  sha256 "c5ce656e0ade49b93e1163ec7b35450721d5743d8d804ad3a9e39add0389e50f"

  bottle do
    cellar :any_skip_relocation
    sha256 "e62545230ae1f9929d497e4aa799dfdd19b0e856307947da7025dfb93535d1b2" => :el_capitan
    sha256 "01261308206a529caaae3b4e6a5a9204f257732ab76602c33085b00d140cfef8" => :yosemite
    sha256 "428bb615dad55b2930c2437a116ee78c2931f1fa0b73d0c615a77c6e0cfc9f78" => :mavericks
    sha256 "9e43b91d6974c7bc4c5d64f081469f679a25b81ba21bd5d23f04c7be47b4f8b8" => :mountain_lion
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
