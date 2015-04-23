class Kes < Formula
  homepage "https://github.com/epilnivek/kes"
  url "https://github.com/epilnivek/kes/archive/v0.9.tar.gz"
  sha256 "d0db16ba7892d9692cacd552d684f03a9d0333ba0e7b629a998fa9c127ef050e"

  head "https://github.com/epilnivek/kes.git"

  depends_on "readline"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-readline"

    bin.mkpath
    man1.mkpath

    system "make", "install"
  end

  test do
    assert_equal "Homebrew\n", shell_output("#{bin}/es -c 'echo Homebrew'")
  end
end
