class Diction < Formula
  desc "GNU diction and style"
  homepage "https://www.gnu.org/software/diction/"
  url "http://ftpmirror.gnu.org/diction/diction-1.11.tar.gz"
  mirror "https://ftp.gnu.org/gnu/diction/diction-1.11.tar.gz"
  sha256 "35c2f1bf8ddf0d5fa9f737ffc8e55230736e5d850ff40b57fdf5ef1d7aa024f6"

  bottle do
    sha256 "ce2b0d6b0f7184596753de94a3cbd171f5236c947f47536d3bf5be806c8ef804" => :yosemite
    sha256 "b993bef13629751dc5ac23a38e67ea8fdce3e75f0d96585dc71508543e099f0e" => :mavericks
    sha256 "f3d0a49027153c0c81928a9648a2211630f6542bbb7bbe283b7265ef8fdab716" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    file = "test.txt"
    (testpath/file).write "The quick brown fox jumps over the lazy dog."
    assert_match /^.*35 characters.*9 words.*$/m, shell_output("#{bin}/style #{file}")
    assert_match /No phrases in 1 sentence found./, shell_output("#{bin}/diction #{file}")
  end
end
