require 'formula'

class Html2text < Formula
  homepage 'http://www.mbayer.de/html2text/'
  url 'http://www.mbayer.de/html2text/downloads/html2text-1.3.2a.tar.gz'
  sha1 '91d46e3218d05b0783bebee96a14f0df0eb9773e'

  # Patch provided by author. See:
  # http://www.mbayer.de/html2text/faq.shtml#sect6
  patch do
    url "http://www.mbayer.de/html2text/downloads/patch-utf8-html2text-1.3.2a.diff"
    sha1 "3e928c75495aa6d8f071bcf61d2ceba0eb748811"
  end

  def install
    inreplace 'configure',
              'for i in "CC" "g++" "cc" "$CC"; do',
              'for i in "g++"; do'

    system "./configure"
    system "make all"

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
