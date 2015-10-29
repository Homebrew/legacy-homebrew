class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "http://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "http://www.pgpool.net/download.php?f=pgpool-II-3.4.3.tar.gz"
  sha256 "b030d1a0dfb919dabb90987f429b03a67b22ecdbeb0ec1bd969ebebe690006e4"

  bottle do
    cellar :any
    sha256 "272ee6246595eecdcb1b44febbe05422f9559aecce4078028448029753d091e2" => :el_capitan
    sha256 "11233e63d5830295ff825d3181aa4240fd81c532b1c7f19889bb3c248f809813" => :yosemite
    sha256 "93c1d153801b4338d2bd2a233787aa570480ba53589d9209cd5f55291b5296df" => :mavericks
  end

  depends_on :postgresql

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    cp etc/"pgpool.conf.sample", testpath/"pgpool.conf"
    system bin/"pg_md5", "--md5auth", "pool_passwd", "--config-file", "pgpool.conf"
  end
end
