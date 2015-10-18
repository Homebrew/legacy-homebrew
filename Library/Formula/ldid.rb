class Ldid < Formula
  desc "Lets you manipulate the signature block in a Mach-O binary"
  homepage "https://cydia.saurik.com/info/ldid/"
  url "git://git.saurik.com/ldid.git",
    :tag => "v1.1.2",
    :revision => "604cc486bdefb246c984a21dbb30cdaf8b0a7f4d"

  head "git://git.saurik.com/ldid.git"

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
