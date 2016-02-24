class Libcdio < Formula
  desc "Compact Disc Input and Control Library"
  homepage "https://www.gnu.org/software/libcdio/"
  url "http://ftpmirror.gnu.org/libcdio/libcdio-0.93.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libcdio/libcdio-0.93.tar.gz"
  sha256 "4972cd22fd8d0e8bff922d35c7a645be0db0ab0e7b3dfaecc9cd8272429d6975"

  bottle do
    cellar :any
    revision 1
    sha256 "e927060058a85e913d7b1d647947982d52d208d5c4ef8471be532ae58db61d0b" => :el_capitan
    sha256 "a75b52450488b5a058aaf6089d731937b3e0cdf643dac6d4ea187c8e0ea8de0b" => :yosemite
    sha256 "b70aafbcf1389b6c40bcce0fe9874acc3ae02ca67a4f0652f46484a46517c900" => :mavericks
    sha256 "5e4dfbdb57def1e77e9327526eb92abe795da59284c6a348e542e55a9bcd8eb4" => :mountain_lion
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/cd-info -v", 1)
  end
end
