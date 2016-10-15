require "formula"

class Cyphertite < Formula
  homepage "https://www.cyphertite.com/"
  url "https://www.cyphertite.com/snapshots/source/2.0.2/cyphertite-full-2.0.2.tar.gz"
  sha1 "87289e27bc82d1ed573328131bb78c8f6c54bb61"

  depends_on "gcc" if MacOS.version < :mountain_lion
  depends_on "libevent"
  depends_on "lzo"
  depends_on "xz"

  def install
    ENV.deparallelize
    make_args = ["LOCALBASE=#{prefix}",
                 "INCFLAGS=-I#{buildpath}/" + %w(assl clens/include/clens clog cyphertite/libcyphertite cyphertite/ctutil exude shrink/libshrink xmlsd).join(" -I#{buildpath}/"),
                 "LDFLAGS=-L#{buildpath}/" + %w(clens clog assl xmlsd shrink/libshrink exude).join(" -L#{buildpath}/")]
    %w(clens clog assl xmlsd shrink exude cyphertite).each {
      |f| system "make", "-C", "#{buildpath}/#{f}", *make_args
    }
    system "make", "-C", "#{buildpath}/cyphertite", "install", *make_args
  end
end
