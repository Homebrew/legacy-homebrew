class Ldid < Formula
  desc "Lets you manipulate the signature block in a Mach-O binary"
  homepage "https://cydia.saurik.com/info/ldid/"
  url "git://git.saurik.com/ldid.git",
    :tag => "v1.2.1",
    :revision => "e4b7adc1e02c9f0e16cc9ae2841192b386f6d4ea"

  head "git://git.saurik.com/ldid.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4dc42bad7354d658bb5061a48957ff9c9e454b49a568c472b2917ccc21b60d5e" => :el_capitan
    sha256 "0eaf7d6f69962f5dd38a0edcea6432fe08b0a2302d97553ab7fea91dbd2508b4" => :yosemite
    sha256 "504f7152bf85b9418aee1ba49dc6b0e07251b4e8a82209fc0ee6ad433f114cc0" => :mavericks
  end

  depends_on "openssl"

  def install
    inreplace "./make.sh", /^.*\/Applications\/Xcode-5.1.1.app.*/, ""
    system "./make.sh"
    bin.install "ldid"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      int main(int argc, char **argv) { return 0; }
    EOS

    system ENV.cc, "test.c", "-o", "test"
    system bin/"ldid", "-S", "test"
  end
end
