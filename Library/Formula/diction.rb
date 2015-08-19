class Diction < Formula
  desc "GNU diction and style"
  homepage "https://www.gnu.org/software/diction/"
  url "http://ftpmirror.gnu.org/diction/diction-1.11.tar.gz"
  mirror "https://ftp.gnu.org/gnu/diction/diction-1.11.tar.gz"
  sha256 "35c2f1bf8ddf0d5fa9f737ffc8e55230736e5d850ff40b57fdf5ef1d7aa024f6"

  bottle do
    sha1 "5a3520b96c45b01b39c14eb55537780fdbaeb830" => :yosemite
    sha1 "cc7d45e7d240f0eef22dfcda475ee9daac382c36" => :mavericks
    sha1 "23b2b3ebafb4434c0097cef9deef057ce1eec850" => :mountain_lion
  end

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
