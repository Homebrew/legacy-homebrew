class LittleCms2 < Formula
  homepage "http://www.littlecms.com/"
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.7/lcms2-2.7.tar.gz"
  sha256 "4524234ae7de185e6b6da5d31d6875085b2198bc63b1211f7dde6e2d197d6a53"

  bottle do
    cellar :any
    revision 1
    sha1 "27bd10360d70c106a8d306871feb990af9df510e" => :yosemite
    sha1 "c67762e471d15d9b84cbc16eaeaa514070c35b3f" => :mavericks
    sha1 "ae3e7282b6e89f3b97ae07c7071674eb89556005" => :mountain_lion
  end

  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :recommended

  option :universal

  def install
    ENV.universal_binary if build.universal?

    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--without-tiff" if build.without? "libtiff"
    args << "--without-jpeg" if build.without? "jpeg"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/jpgicc", test_fixtures("test.jpg"), "out.jpg"
    assert File.exist?("out.jpg")
  end
end
