class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "http://www.littlecms.com/"
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.7/lcms2-2.7.tar.gz"
  sha256 "4524234ae7de185e6b6da5d31d6875085b2198bc63b1211f7dde6e2d197d6a53"

  bottle do
    cellar :any
    sha256 "5743b278bd645a38e65c712c8b5f3cd5befb64fde954472e42993378923fbc6e" => :el_capitan
    sha256 "1277de3dbdc30ceb5fe5a789c495b5b73d5f8590f0827f3dfef7637ed527e915" => :yosemite
    sha256 "84a55d5895d81d60a1ac66f9b13e8024e4dd33fd8cde69aa34cd7b1213ade786" => :mavericks
    sha256 "a1e7a20c35f166372c4907f505b0ed0a560d64cfad88c795681817035930af38" => :mountain_lion
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
