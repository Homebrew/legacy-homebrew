class Cksfv < Formula
  desc "File verification utility"
  homepage "http://zakalwe.fi/~shd/foss/cksfv/"
  url "http://zakalwe.fi/~shd/foss/cksfv/files/cksfv-1.3.14.tar.bz2"
  sha256 "8f3c246f3a4a1f0136842a2108568297e66e92f5996e0945d186c27bca07df52"

  bottle do
    cellar :any_skip_relocation
    sha256 "41d81d535cfa41b4eb03709e646b0bdc36a78f99c8e15746b7eb289a98afbb97" => :el_capitan
    sha256 "9885cadccdeec56d0f665bad80655cfba3397c3ff2958c7a44af514a69bc8114" => :yosemite
    sha256 "3838548d5febbed5d9db37e8634397a589bcec766ee5ec84949a17dae9b34cdd" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"foo"
    path.write "abcd"

    assert_match "#{path} ED82CD11", shell_output("#{bin}/cksfv #{path}")
  end
end
