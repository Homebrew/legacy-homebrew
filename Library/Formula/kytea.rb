class Kytea < Formula
  desc "Toolkit for analyzing text, especially Japanese and Chinese"
  homepage "http://www.phontron.com/kytea/"
  url "http://www.phontron.com/kytea/download/kytea-0.4.7.tar.gz"
  sha256 "534a33d40c4dc5421f053c71a75695c377df737169f965573175df5d2cff9f46"

  bottle do
    sha256 "2f2dda314728cd74750db339ebc2d166b8b611ad54668cc3e7b6225d39aec3f5" => :yosemite
    sha256 "045d0c9ad0cf35e003b8839cb0213e3f49d9107dfbc955e449b36fd4b6596640" => :mavericks
    sha256 "3f15b353a447519bfb7f602b29db18e7eff945e0b68998af35cc37a745328182" => :mountain_lion
  end

  head do
    url "https://github.com/neubig/kytea.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
