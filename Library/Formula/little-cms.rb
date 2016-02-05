class LittleCms < Formula
  desc "Version 1 of the Little CMS library"
  homepage "http://www.littlecms.com/"
  url "https://downloads.sourceforge.net/project/lcms/lcms/1.19/lcms-1.19.tar.gz"
  sha256 "80ae32cb9f568af4dc7ee4d3c05a4c31fc513fc3e31730fed0ce7378237273a9"

  bottle do
    cellar :any
    revision 1
    sha256 "c1dd6107f2d5e565f35e8358bd968ba7161ad3809d1b5bab4a412d3f01ec874f" => :el_capitan
    sha256 "48da368fcf57745e933d4022dbd1d64b79a66eeaa76064ceb6f6c4e792fde776" => :yosemite
    sha256 "175c804307189d9d0d700a423d6daa9d839ec5d3038145f311f436bd1aa71392" => :mavericks
    sha256 "0d2af3b585f79b60e617301d5251a19114e14f82b5b75f3feda5be11c09404da" => :mountain_lion
  end

  option :universal

  depends_on :python => :optional
  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :recommended

  def install
    ENV.universal_binary if build.universal?
    args = %W[--disable-dependency-tracking --disable-debug --prefix=#{prefix}]
    args << "--without-tiff" if build.without? "libtiff"
    args << "--without-jpeg" if build.without? "jpeg"
    if build.with? "python"
      args << "--with-python"
      inreplace "python/Makefile.in" do |s|
        s.change_make_var! "pkgdir", lib/"python2.7/site-packages"
      end
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system "#{bin}/jpegicc", test_fixtures("test.jpg"), "out.jpg"
    assert File.exist?("out.jpg")
  end
end
