class XarMackyle < Formula
  desc "eXtensible ARchiver"
  homepage "https://mackyle.github.io/xar/"
  url "https://github.com/downloads/mackyle/xar/xar-1.6.1.tar.gz"
  sha256 "ee46089968457cf710b8cf1bdeb98b7ef232eb8a4cdeb34502e1f16ef4d2153e"

  bottle do
    sha256 "36bea8e87e71c9ffb5e763771b6c23b0dd34a367bdb9d36d1ee945cc936e492d" => :yosemite
    sha256 "fe7a02bfdf51cbd9d931f4783e0fb2024604d7a4505bdf5ae1a5ed34e441dcbc" => :mavericks
    sha256 "2fdd4f84b6e755e7bab16b0f7f783569575a7d9d74b271940c2386981b1febfc" => :mountain_lion
  end

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
