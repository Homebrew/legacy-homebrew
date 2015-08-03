class Corkscrew < Formula
  desc "Tunnel SSH through HTTP proxies"
  homepage "http://www.agroman.net/corkscrew/"
  url "http://www.agroman.net/corkscrew/corkscrew-2.0.tar.gz"
  sha256 "0d0fcbb41cba4a81c4ab494459472086f377f9edb78a2e2238ed19b58956b0be"

  depends_on "libtool" => :build

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
