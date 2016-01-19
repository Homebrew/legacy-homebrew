class Par < Formula
  desc "Paragraph reflow for email"
  homepage "http://www.nicemice.net/par/"
  url "http://www.nicemice.net/par/Par152.tar.gz"
  version "1.52"
  sha256 "33dcdae905f4b4267b4dc1f3efb032d79705ca8d2122e17efdecfd8162067082"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "2dd2b1808f820354b03927fc30b11eeb33bd5704877756938cb8c5daac18a393" => :el_capitan
    sha256 "195a82f58ad34fe5d4e3c061a6d83909017861ede1e8af5668ef2062e0c0bdcb" => :yosemite
    sha256 "3d666b815997eda86ee0f96e71ba6fca3193432c5a01affb59918f22408c8dc6" => :mavericks
  end

  conflicts_with "rancid", :because => "both install `par` binaries"

  # A patch by Jérôme Pouiller that adds support for multibyte
  # charsets (like UTF-8), plus Debian packaging.
  patch do
    url "http://sysmic.org/dl/par/par-1.52-i18n.4.patch"
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
