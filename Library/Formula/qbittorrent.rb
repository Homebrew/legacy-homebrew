class Qbittorrent < Formula
  desc "Qt based free and reliable P2P Bittorrent client"
  homepage 'http://www.qbittorrent.org'
  url 'https://github.com/qbittorrent/qBittorrent/archive/release-3.2.3.tar.gz'
  sha256 "816d611a0af50c469f52946c94b88c003f908ee031ee0e55a45273e4c64897c5"
  head 'https://github.com/qbittorrent/qBittorrent.git',
    :branch => ENV['QBT_BRANCH'] || "master"

  depends_on "pkg-config" => :build
  depends_on "qt" => :build
  depends_on "libtorrent-rasterbar" => :build
  depends_on "boost" => :build
  depends_on "gnu-sed" => :build

  resource "geoIP" do
    url "http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz"
    sha256 "c03b4b8e10d67626fb3cd67cb338d186ce49273be60519dc4ad2ff073437bb87"
  end

  def install
    (buildpath/"src/gui/geoIP").install resource("geoIP") if build.stable?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-qt-dbus"
    system "make"
    system "macdeployqt src/qBittorrent.app"
    prefix.install "src/qBittorrent.app"
  end

  test do
    system "#{prefix}/qBittorrent.app/Contents/MacOS/qbittorrent", "-v"
  end

end
