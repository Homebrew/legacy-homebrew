class Shntool < Formula
  homepage "http://etree.org/shnutils/shntool/"
  url "http://etree.org/shnutils/shntool/dist/src/shntool-3.0.10.tar.gz"
  sha256 "74302eac477ca08fb2b42b9f154cc870593aec8beab308676e4373a5e4ca2102"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/shninfo", test_fixtures("test.wav")
  end
end
