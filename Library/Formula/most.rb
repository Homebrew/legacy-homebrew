class Most < Formula
  homepage "http://www.jedsoft.org/most/"
  url "ftp://space.mit.edu/pub/davis/most/most-5.0.0a.tar.bz2"
  sha256 "94cb5a2e71b6b9063116f4398a002a757e59cd1499f1019dde8874f408485aa9"

  head "git://git.jedsoft.org/git/most.git"

  depends_on "s-lang"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-slang=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end

  test do
    text = "This is Homebrew"
    assert_equal text, pipe_output("#{bin}/most -C", text)
  end
end
