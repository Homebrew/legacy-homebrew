class Epeg < Formula
  desc "JPEG/JPG thumbnail scaling"
  homepage "https://github.com/mattes/epeg"
  url "https://github.com/mattes/epeg/archive/v0.9.1.042.tar.gz"
  sha256 "644362f87605e92f1e1cc0c421867252e4402939aeb4b36ad7cb385cc57a137c"

  head "https://github.com/mattes/epeg.git"

  bottle do
    cellar :any
    sha256 "b2d3f25d28280107b503d31ebfdb59bf452fc117d027fa136934b621a922b0a4" => :el_capitan
    sha256 "f7abbd3547174648e37bd74d73e5ec0a6e4f8391c97a1153d0ed63adc7b02193" => :yosemite
    sha256 "617efb3a645d90f883921752c45d298178e26f535270c38fb46c44a46e3fcc9d" => :mavericks
    sha256 "3caf1686250bbd6933e5c5e1cc03c79eeffff3877e07087549acd75334319547" => :mountain_lion
  end

  depends_on "automake" => :build
  depends_on "jpeg"
  depends_on "libexif"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "epeg", "--width=1",
                   "--height=1",
                   test_fixtures("test.jpg")
    "out.jpg"
  end
end
