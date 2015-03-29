class XarMackyle < Formula
  homepage "https://mackyle.github.io/xar/"
  url "https://github.com/downloads/mackyle/xar/xar-1.6.1.tar.gz"
  sha256 "ee46089968457cf710b8cf1bdeb98b7ef232eb8a4cdeb34502e1f16ef4d2153e"

  conflicts_with "xar", :because => "both install a `xar` binary"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    touch "testfile.txt"
    system bin/"xar", "-cv", "testfile.txt", "-f", "test.xar"
    assert File.exist?("test.xar")
    assert_match /testfile.txt/, shell_output("#{bin}/xar -tv -f test.xar")
  end
end
