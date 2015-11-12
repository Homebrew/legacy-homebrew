class Minisign < Formula
  desc "Sign files & verify signatures. Works with signify in OpenBSD."
  homepage "https://jedisct1.github.io/minisign/"
  url "https://github.com/jedisct1/minisign/archive/0.6.tar.gz"
  sha256 "f2267a07bece923d4d174ccacccc56eff9c05b28c4d971e601de896355442f09"

  bottle do
    cellar :any
    sha256 "8ba8bd4efa18b1bb418fbfe0f734e36b497f50fdcdd7c90ba33c054ed03f8cf5" => :el_capitan
    sha256 "51078510d83f37e6df87bd601d6f593e88798500249a05c5b431f756bd41ae62" => :yosemite
    sha256 "0327b84d602a990be9046a3fead0e219a4cfd0f5f66e0128842b7c2e0898bc79" => :mavericks
  end

  depends_on "libsodium"
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"homebrew.txt").write "Hello World!"
    (testpath/"keygen.sh").write <<-EOS.undent
      #!/usr/bin/expect -f
      set timeout -1
      spawn #{bin}/minisign -G
      expect -exact "Please enter a password to protect the secret key."
      expect -exact "\n"
      expect -exact "Password: "
      send -- "Homebrew\n"
      expect -exact "\r
      Password (one more time): "
      send -- "Homebrew\n"
      expect eof
    EOS
    chmod 0755, testpath/"keygen.sh"

    system "./keygen.sh"
    assert File.exist?("minisign.pub")
    assert File.exist?("minisign.key")

    (testpath/"signing.sh").write <<-EOS.undent
      #!/usr/bin/expect -f
      set timeout -1
      spawn #{bin}/minisign -Sm homebrew.txt
      expect -exact "Password: "
      send -- "Homebrew\n"
      expect eof
    EOS
    chmod 0755, testpath/"signing.sh"

    system "./signing.sh"
    assert File.exist?("homebrew.txt.minisig")
  end
end
