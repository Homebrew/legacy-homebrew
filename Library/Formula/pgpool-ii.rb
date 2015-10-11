class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "http://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "http://www.pgpool.net/download.php?f=pgpool-II-3.4.3.tar.gz"
  sha256 "b030d1a0dfb919dabb90987f429b03a67b22ecdbeb0ec1bd969ebebe690006e4"

  bottle do
    sha256 "8d439ca3292ce18c4af1f6d7e1b67d6c4be269f753244923348138ee87ded8b0" => :yosemite
    sha256 "d7d92779769bdf201a4233451bc4d88da1137ecadfa53e1b71f66ca9c6dfab35" => :mavericks
    sha256 "5aba63321d6c9c294adb20d1a0043283a09e94b1c43b2f19c1d730823407d231" => :mountain_lion
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
