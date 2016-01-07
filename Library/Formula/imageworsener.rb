class Imageworsener < Formula
  desc "Utility and library for image scaling and processing"
  homepage "http://entropymine.com/imageworsener/"
  url "http://entropymine.com/imageworsener/imageworsener-1.3.0.tar.gz"
  sha256 "2d4e40463658a577056ee17f204aac2a626b291f187f5f6e42b0c4140408d125"

  bottle do
    cellar :any
    sha256 "37bae78184cee10bef03a1bb927bd7b4310e12eec8d9cede33a01a6f3eb50ead" => :el_capitan
    sha256 "18495cbe551d223ab723bb0dd477322a1c75a04191a0a4df264b17765025fa64" => :yosemite
    sha256 "26f7718a20005d76eedc46023a45a70cceea07cd86123b59d2809e8b3bb291d5" => :mavericks
  end

  head do
    url "https://github.com/jsummers/imageworsener.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "libpng" => :recommended
  depends_on "jpeg" => :optional
  depends_on "webp" => :optional

  def install
    if build.head?
      inreplace "./scripts/autogen.sh", "libtoolize", "glibtoolize"
      system "./scripts/autogen.sh"
    end
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--without-jpeg" if build.without? "jpeg"
    args << "--without-webp" if build.without? "webp"

    system "./configure", *args
    system "make", "install"
    share.install "tests"
  end

  test do
    cp_r Dir["#{share}/tests/*"], testpath
    system "./runtest", bin/"imagew"
  end
end
