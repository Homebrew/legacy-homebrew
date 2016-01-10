class TalkFilters < Formula
  desc "Convert English text to stereotyped or humorous dialects"
  homepage "http://www.hyperrealm.com/main.php?s=talkfilters"
  url "http://www.hyperrealm.com/talkfilters/talkfilters-2.3.8.tar.gz"
  sha256 "4681e71170af06c6bffcd4e454eff67224cde06f0d678d26dc72da45f02ecca6"

  bottle do
    cellar :any
    sha256 "c6179286e4f8da465545b13a1be1fac71f88720db214479d5869a7c340e99d45" => :yosemite
    sha256 "8b6338ab885adb817eaa47c639f247fc0bb40c5372782af1412e434bc58c0e4a" => :mavericks
    sha256 "10bb0f88a6d8c6fc726677611fd115e71d9df1dcfc80e13ecab36fe1da9ee6f8" => :mountain_lion
  end

  conflicts_with "muttils", :because => "both install `wrap` binaries"

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
