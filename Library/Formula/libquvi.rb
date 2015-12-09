class Libquvi < Formula
  desc "C library to parse flash media stream properties"
  homepage "http://quvi.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/quvi/0.4/libquvi/libquvi-0.4.1.tar.bz2"
  sha256 "f5a2fb0571634483e8a957910f44e739f5a72eb9a1900bd10b453c49b8d5f49d"
  revision 1

  bottle do
    revision 2
    sha256 "4c3c315b1e35035d53cb8e8790ba25dccbea794df755d5a28a3ce465166fa6fa" => :el_capitan
    sha256 "99375bca427fb5cc368da9b09bec8890f87896b0d2329780420e1a4d2c131e16" => :yosemite
    sha256 "b83f94653852b748d4e23a6ade9d5668a7052bf4747cb23c751d70b0698f9689" => :mavericks
    sha256 "a252b3f6e2487839f1a3c352522ba5729f5adf200f418c8f5c7cfed7283b5171" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "lua"

  resource "scripts" do
    url "https://downloads.sourceforge.net/project/quvi/0.4/libquvi-scripts/libquvi-scripts-0.4.14.tar.xz"
    sha256 "b8d17d53895685031cd271cf23e33b545ad38cad1c3bddcf7784571382674c65"
  end

  def install
    scripts = prefix/"libquvi-scripts"
    resource("scripts").stage do
      system "./configure", "--prefix=#{scripts}", "--with-nsfw"
      system "make", "install"
    end
    ENV.append_path "PKG_CONFIG_PATH", "#{scripts}/lib/pkgconfig"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
