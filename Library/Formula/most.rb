class Most < Formula
  desc "Powerful paging program"
  homepage "http://www.jedsoft.org/most/"
  url "http://www.jedsoft.org/releases/most/most-5.0.0a.tar.bz2"
  sha256 "94cb5a2e71b6b9063116f4398a002a757e59cd1499f1019dde8874f408485aa9"

  head "git://git.jedsoft.org/git/most.git"

  bottle do
    sha256 "9e645b60950d18dea0b58c95b0525992cb55bbddc5cdc664dce11e94b552e568" => :el_capitan
    sha256 "7b2828c656ba7ef31fc03d5570f8d6701f365fd4a96252bcdfae66b266713bc3" => :yosemite
    sha256 "f7d99563678653a673eddee924ca90f76819eed8a25a47780762571f35187241" => :mavericks
    sha256 "a5e6342f6f4046aa9f47b588734a4f0ad614aa3c461a83fe61a4d4f2666e792b" => :mountain_lion
  end

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
