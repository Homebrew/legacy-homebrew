class LittleCms < Formula
  desc "Version 1 of the Little CMS library"
  homepage "http://www.littlecms.com/"
  url "https://downloads.sourceforge.net/project/lcms/lcms/1.19/lcms-1.19.tar.gz"
  sha1 "d5b075ccffc0068015f74f78e4bc39138bcfe2d4"

  bottle do
    cellar :any
    revision 1
    sha1 "bf1ee324d9c03017d15e380e5f6efc25ec8e2831" => :yosemite
    sha1 "3642f7bcd6d1e64826b3a184a000fe6e3ea9ad0f" => :mavericks
    sha1 "bc893b9e8deeaed1a4cd2f84595d17f8a7e44d76" => :mountain_lion
  end

  option :universal

  depends_on :python => :optional
  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :recommended

  def install
    ENV.universal_binary if build.universal?
    args = %W{--disable-dependency-tracking --disable-debug --prefix=#{prefix}}
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
