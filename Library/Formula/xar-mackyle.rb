class XarMackyle < Formula
  homepage "https://mackyle.github.io/xar/"
  url "https://github.com/downloads/mackyle/xar/xar-1.6.1.tar.gz"
  sha256 "ee46089968457cf710b8cf1bdeb98b7ef232eb8a4cdeb34502e1f16ef4d2153e"

  depends_on "openssl"
  depends_on "xz"

  def install
    system "./configure", "--prefix=#{libexec}"
    system "make"
    system "make", "install"

    bin.install_symlink libexec/"bin/xar" => "xar-mackyle"
    man1.install_symlink libexec/"share/man/man1/xar.1" => "xar-mackyle.1"
  end

  test do
    touch "testfile.txt"
    system libexec/"bin/xar", "-cv", "testfile.txt", "-f", "test.xar"
    assert File.exist?("test.xar")
    assert_match /testfile.txt/, shell_output("#{libexec}/bin/xar -tv -f test.xar")
  end
end
