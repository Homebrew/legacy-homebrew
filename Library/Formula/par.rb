class Par < Formula
  desc "Paragraph reflow for email"
  homepage "http://www.nicemice.net/par/"
  url "http://www.nicemice.net/par/Par152.tar.gz"
  version "1.52"
  sha256 "33dcdae905f4b4267b4dc1f3efb032d79705ca8d2122e17efdecfd8162067082"

  bottle do
    cellar :any
    sha1 "ae7b305c39ebd6f752f74618918445b1e64ebd62" => :yosemite
    sha1 "2ff8b8dad47f68a189bd8c6efbbb3432143e195b" => :mavericks
    sha1 "9e4409e4e71a8f6b45ca1e38e53b257d69a3decd" => :mountain_lion
  end

  conflicts_with "rancid", :because => "both install `par` binaries"

  # A patch by Jérôme Pouiller that adds support for multibyte
  # charsets (like UTF-8), plus Debian packaging.
  patch do
    url "http://sysmic.org/dl/par/par_1.52-i18n.4.patch"
    sha256 "2ab2d6039529aa3e7aff4920c1630003b8c97c722c8adc6d7762aa34e795861e"
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
