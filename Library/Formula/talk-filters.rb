class TalkFilters < Formula
  homepage "http://www.hyperrealm.com/main.php?s=talkfilters"
  url "http://www.hyperrealm.com/talkfilters/talkfilters-2.3.8.tar.gz"
  sha256 "4681e71170af06c6bffcd4e454eff67224cde06f0d678d26dc72da45f02ecca6"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "MKDIR_P=mkdir -p", "install"
  end

  test do
    assert_equal "hellu Humebroo",
      pipe_output("#{bin}/chef", "hello Homebrew", 0)
  end
end
