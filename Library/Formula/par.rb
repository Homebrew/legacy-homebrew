class Par < Formula
  desc "Paragraph reflow for email"
  homepage "http://www.nicemice.net/par/"
  url "http://www.nicemice.net/par/Par152.tar.gz"
  version "1.52"
  sha1 "4b83d2ec593bb45ee46d4b7c2bfc590e1f4a41a8"

  bottle do
    cellar :any
    sha1 "ae7b305c39ebd6f752f74618918445b1e64ebd62" => :yosemite
    sha1 "2ff8b8dad47f68a189bd8c6efbbb3432143e195b" => :mavericks
    sha1 "9e4409e4e71a8f6b45ca1e38e53b257d69a3decd" => :mountain_lion
  end

  # A patch by Jérôme Pouiller that adds support for multibyte
  # charsets (like UTF-8), plus Debian packaging.
  patch do
    url "http://sysmic.org/dl/par/par_1.52-i18n.4.patch"
    sha1 "9f774372c7eedc6970aa7e4ff40692428cbd84ee"
  end

  def install
    system "make", "-f", "protoMakefile"
    bin.install "par"
    man1.install gzip("par.1")
  end

  test do
    expected = "homebrew\nhomebrew\n"
    assert_equal expected, pipe_output("#{bin}/par 10gqr", "homebrew homebrew")
  end
end
