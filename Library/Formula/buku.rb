class Buku < Formula
  desc "Command-line bookmark manager"
  homepage "https://github.com/jarun/Buku"
  url "https://github.com/jarun/Buku/archive/1.7.tar.gz"
  sha256 "0baf1594b1bf4bf47dc6b6c1e011a49e07bb6f8b6ce5f637c321f17382d9fdb2"

  depends_on :python3

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/buku", "-a", "https://github.com/Homebrew/homebrew"
    assert_match %r{https://github.com/Homebrew/homebrew}, shell_output("#{bin}/buku -s github </dev/null")
  end
end
