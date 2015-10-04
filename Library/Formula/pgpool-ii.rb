class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "http://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "http://www.pgpool.net/download.php?f=pgpool-II-3.4.2.tar.gz"
  sha256 "d031fea1313eaf84116f16bc6d0053c9432b04da160e5544ab6445c1f876c351"

  bottle do
    sha256 "8d439ca3292ce18c4af1f6d7e1b67d6c4be269f753244923348138ee87ded8b0" => :yosemite
    sha256 "d7d92779769bdf201a4233451bc4d88da1137ecadfa53e1b71f66ca9c6dfab35" => :mavericks
    sha256 "5aba63321d6c9c294adb20d1a0043283a09e94b1c43b2f19c1d730823407d231" => :mountain_lion
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
