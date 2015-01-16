class Colortail < Formula
  homepage "http://joakimandersson.se/projects/colortail/"
  url "http://joakimandersson.se/files/colortail-0.3.3.tar.gz"
  sha1 "2c6cf501758cbc0f8a46d0b2122839e5cb30fdfc"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write("Hello\nWorld!\n")
    assert_match /World!/, shell_output("#{bin}/colortail -n 1 test.txt")
  end
end
