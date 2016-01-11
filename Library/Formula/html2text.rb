class Html2text < Formula
  desc "Advanced HTML-to-text converter"
  homepage "http://www.mbayer.de/html2text/"
  url "http://www.mbayer.de/html2text/downloads/html2text-1.3.2a.tar.gz"
  sha256 "000b39d5d910b867ff7e087177b470a1e26e2819920dcffd5991c33f6d480392"

  # Patch provided by author. See:
  # http://www.mbayer.de/html2text/faq.shtml#sect6
  patch do
    url "http://www.mbayer.de/html2text/downloads/patch-utf8-html2text-1.3.2a.diff"
    sha256 "be4e90094d2854059924cb2c59ca31a5e9e0e22d2245fa5dc0c03f604798c5d1"
  end

  def install
    inreplace "configure",
              'for i in "CC" "g++" "cc" "$CC"; do',
              'for i in "g++"; do'

    system "./configure"
    system "make", "all"

    bin.install "html2text"
    man1.install "html2text.1.gz"
    man5.install "html2textrc.5.gz"
  end

  test do
    path = testpath/"index.html"
    path.write <<-EOS.undent
      <!DOCTYPE html>
      <html>
        <head><title>Home</title></head>
        <body><p>Hello World</p></body>
      </html>
    EOS

    output = `#{bin}/html2text #{path}`.strip
    assert_equal "Hello World", output
    assert_equal 0, $?.exitstatus
  end
end
