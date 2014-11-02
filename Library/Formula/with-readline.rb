require "formula"

class WithReadline < Formula
  homepage "http://www.greenend.org.uk/rjk/sw/withreadline.html"
  url "http://www.greenend.org.uk/rjk/sw/with-readline-0.1.1.tar.gz"
  sha1 "ac32f4b23853024f2a42441fa09b20cbe7617ff5"

  depends_on "readline"

  option :universal

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Some test is better than no test
    system bin/"with-readline", "--version"
    system bin/"echo 'exit' | with-readline expect"
  end
end
