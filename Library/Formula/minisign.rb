class Minisign < Formula
  desc "Sign files & verify signatures. Works with signify in OpenBSD."
  homepage "https://jedisct1.github.io/minisign/"
  url "https://github.com/jedisct1/minisign/archive/0.4.tar.gz"
  sha256 "dc7695513e715654a51d07ad3e6b0083f9cb38b1a5bc9f16e1177d15af992dcc"
  revision 1

  bottle do
    cellar :any
    sha256 "fa7d3a052ade5f41d53edc114b369460f543f5676a4c6b541866b14db3ced3ff" => :el_capitan
    sha256 "2710174b100c657f71006a14a4035b533cd0bc61fd2a7699b46e6bc8a3a530b9" => :yosemite
    sha256 "a3b96531c0c259d802ea34224d642800a6c4ea95d46aa9b88eacfd23d53428df" => :mavericks
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
