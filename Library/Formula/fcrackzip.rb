class Fcrackzip < Formula
  desc "Zip password cracker"
  homepage "http://oldhome.schmorp.de/marc/fcrackzip.html"
  url "http://oldhome.schmorp.de/marc/data/fcrackzip-1.0.tar.gz"
  sha256 "4a58c8cb98177514ba17ee30d28d4927918bf0bdc3c94d260adfee44d2d43850"

  bottle do
    cellar :any_skip_relocation
    sha256 "169a5e7ea0e7ee9d04dc7ecce5288ef3a096fc9875d9af134b342878ce8c55fd" => :el_capitan
    sha256 "1e9a5e3d9d37ce1bf7338d3f12f84bf67b31de4e2a6eb1511f90458c45b1b810" => :yosemite
    sha256 "305533df364c7b91ae837dc38b3632bc9e2f0d167e10ad94901b5f2c06ab4924" => :mavericks
    sha256 "12265c59a1196d5f0c5a3c1e362ada6ec2ee9024d81a4cec3633553b7a1395ca" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"secret").write "homebrew"
    system "zip", "-qe", "-P", "a", "secret.zip", "secret"
    assert_equal "PASSWORD FOUND!!!!: pw == a",
                 shell_output("#{bin}/fcrackzip -u -l 1 secret.zip").strip
  end
end
