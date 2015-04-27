class Imageworsener < Formula
  homepage "http://entropymine.com/imageworsener/"
  url "http://entropymine.com/imageworsener/imageworsener-1.2.0.tar.gz"
  sha256 "97fdb1aafac7bc2339b2ce813071f0900de0b093b96ab1a99a43f9647afdfe35"

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
    cd share/"tests" do
      system "./runtest", bin/"imagew"
    end
  end
end
