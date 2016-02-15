class Aespipe < Formula
  desc "AES encryption or decryption for pipes"
  homepage "http://loop-aes.sourceforge.net/"
  url "http://loop-aes.sourceforge.net/aespipe/aespipe-v2.4c.tar.bz2"
  sha256 "260190beea911190a839e711f610ec3454a9b13985d35479775b7e26ad4c845e"

  bottle do
    cellar :any
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
