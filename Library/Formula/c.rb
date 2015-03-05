class C < Formula
  homepage "https://github.com/ryanmjacobs/c"
  url "https://github.com/ryanmjacobs/c/archive/v0.06.tar.gz"
  sha1 "0eefb3523abccea7ebdd2c56d4d7be6f23585645"

  depends_on "gnu-sed"

  def install
    inreplace "c", "sed", "gsed"
    bin.install "c"
  end

  test do
    system "c", "--help"
  end
end
