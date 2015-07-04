class Libquvi < Formula
  desc "C library to parse flash media stream properties"
  homepage "http://quvi.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/quvi/0.4/libquvi/libquvi-0.4.1.tar.bz2"
  sha256 "f5a2fb0571634483e8a957910f44e739f5a72eb9a1900bd10b453c49b8d5f49d"
  revision 1

  bottle do
    revision 1
    sha1 "2b219665889be92e7aae5bc93ccedd956a4a5bf6" => :yosemite
    sha1 "6b9ec93ae6c4b064943befc40596b724a9773618" => :mavericks
    sha1 "6a963aa4d1ce0eb5768a529f07227621b320bab0" => :mountain_lion
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
