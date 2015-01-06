class Diction < Formula
  homepage "https://www.gnu.org/software/diction/"
  url "http://ftpmirror.gnu.org/diction/diction-1.11.tar.gz"
  mirror "https://ftp.gnu.org/gnu/diction/diction-1.11.tar.gz"
  sha1 "30c7c778959120d30fa67be9261d41de894f498b"

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
