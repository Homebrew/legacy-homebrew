class Minised < Formula
  homepage "http://www.exactcode.de/site/open_source/minised/"
  url "http://dl.exactcode.de/oss/minised/minised-1.15.tar.gz"
  sha256 "ada36a55b71d1f2eb61f2f3b95f112708ce51e69f601bf5ea5d7acb7c21b3481"

  def install
    system "make"
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
  end

  test do
    output = pipe_output("#{bin}/minised 's:o::'", "hello world", 0)
    assert_equal "hell world", output.chomp
  end
end
