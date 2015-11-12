class Minisign < Formula
  desc "Sign files & verify signatures. Works with signify in OpenBSD."
  homepage "https://jedisct1.github.io/minisign/"
  url "https://github.com/jedisct1/minisign/archive/0.6.tar.gz"
  sha256 "f2267a07bece923d4d174ccacccc56eff9c05b28c4d971e601de896355442f09"

  bottle do
    cellar :any
    sha256 "65b7a36e3090ccc3bf36cf6e9db6d0f4bafddc02367a9708f8d8dd7ec3dca785" => :el_capitan
    sha256 "71e0499e55343f41e3a7761fb90085b8b7c72fcf3928c0685a3c7d69f7faa0d0" => :yosemite
    sha256 "ce86a3055695f8b760440702c240edd5166539caf99ebc8cf6b8d3f5ea17d487" => :mavericks
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
