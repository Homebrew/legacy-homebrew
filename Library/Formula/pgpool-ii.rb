class PgpoolIi < Formula
  homepage "http://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "http://www.pgpool.net/download.php?f=pgpool-II-3.4.2.tar.gz"
  sha256 "d031fea1313eaf84116f16bc6d0053c9432b04da160e5544ab6445c1f876c351"

  bottle do
    sha1 "b05f96a3f5d0ff02afea65aa50fa33ca1f75defb" => :yosemite
    sha1 "621632adc180b378e427e21587c0c005e8b125db" => :mavericks
    sha1 "26d1434b15ce5f716012bc204b8b01e05b0574c7" => :mountain_lion
  end

  depends_on :postgresql

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"pg_md5", "--md5auth", "pool_passwd", "--config-file", etc/"pgpool.conf.sample"
  end
end
