class Mp3unicode < Formula
  desc "Command-line utility to convert mp3 tags between different encodings"
  homepage "http://mp3unicode.sourceforge.net/"
  url "https://github.com/downloads/alonbl/mp3unicode/mp3unicode-1.2.1.tar.bz2"
  sha256 "375b432ce784407e74fceb055d115bf83b1bd04a83b95256171e1a36e00cfe07"

  bottle do
    cellar :any
    sha256 "e9db3c9529d5358f83bb67d5966c6b508851f27a3bc61d5212b674d620a03a7e" => :el_capitan
    sha256 "56c77d872d7adda53f68661145a5b372ecf64ef0284181a7ecd9b56997f14c74" => :yosemite
    sha256 "10d647d04714f9e95d9bf3ab8dfd023fea3f22876dfe055c01211e527a2facd3" => :mavericks
  end

  head do
    url "https://github.com/alonbl/mp3unicode.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "taglib"

  def install
    ENV.append "ICONV_LIBS", "-liconv"

    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/mp3unicode", "-s", "ASCII", "-w", test_fixtures("test.mp3")
  end
end
