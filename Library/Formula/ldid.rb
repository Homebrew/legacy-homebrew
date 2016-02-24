class Ldid < Formula
  desc "Lets you manipulate the signature block in a Mach-O binary"
  homepage "https://cydia.saurik.com/info/ldid/"
  url "git://git.saurik.com/ldid.git",
    :tag => "v1.1.2",
    :revision => "604cc486bdefb246c984a21dbb30cdaf8b0a7f4d"

  head "git://git.saurik.com/ldid.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4778b00a0baf3e32531315aaed1409ad5e03a14b70f662bd0bb0201ced449a29" => :el_capitan
    sha256 "17d35f08f1d5c90a6c48a8d75369702bf792d731f7df5cc9e3bcc8f7af20f93d" => :yosemite
    sha256 "bd0284ce2fee6ffb64e4cf6bb1bf8585a30f6c6dc074b325f31ba488664f529f" => :mavericks
  end

  depends_on "openssl"

  def install
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
