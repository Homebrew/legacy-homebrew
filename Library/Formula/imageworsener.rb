class Imageworsener < Formula
  desc "Utility and library for image scaling and processing"
  homepage "http://entropymine.com/imageworsener/"
  url "http://entropymine.com/imageworsener/imageworsener-1.3.0.tar.gz"
  sha256 "2d4e40463658a577056ee17f204aac2a626b291f187f5f6e42b0c4140408d125"

  bottle do
    cellar :any
    sha256 "514f4b5327d2b475f4ff68503ff851090981a0c421ee35da434e3563b7b27ecb" => :yosemite
    sha256 "e9b6a217b1681a913f23da975a8d66f99ae3fe860c742590a57ac3d0661fc831" => :mavericks
    sha256 "b62d7e61417b9d0b611e95df27d1cca885487b9197fb6f027cdd849a25932dbc" => :mountain_lion
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
    cd share/"tests" do
      system "./runtest", bin/"imagew"
    end
  end
end
