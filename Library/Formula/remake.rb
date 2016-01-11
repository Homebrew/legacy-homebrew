class Remake < Formula
  desc "GNU Make with improved error handling, tracing, and a debugger"
  homepage "http://bashdb.sourceforge.net/remake/"
  url "https://downloads.sourceforge.net/project/bashdb/remake/4.1%2Bdbg-0.91/remake-4.1%2Bdbg0.91.tar.bz2"
  sha256 "02a1c62b47e99376701f8d99b45fffdf44e8512ecf92794fc6bf5d6779900dfb"

  bottle do
    sha256 "521c4370d42f1ceca81eb9b665a8886162f3c1ee7497ec0a66a9edc15c183502" => :yosemite
    sha256 "260d1ac2aac0f356a2548152d70a0cc4c68817fdc5f59fb505454aca7076a236" => :mavericks
    sha256 "685c98bcbdc8a9c4586802c9d73b895c0ff0a91df2ae3ee78dab57d7cfdba68e" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"Makefile").write <<-EOS.undent
      all:
      \techo "Nothing here, move along"
    EOS
    system bin/"remake", "-x"
  end
end
