class Pure < Formula
  desc "functional programming language based on term rewriting"
  homepage "http://purelang.bitbucket.org"
  url "https://bitbucket.org/purelang/pure-lang/downloads/pure-0.64.tar.gz"
  sha256 "efd55229342aec9d79e8fa4732a30f140e1773064f3869abde053e01468f7b07"

  depends_on "llvm34"

  def install
    ENV.deparallelize
    system "./configure", "--enable-release",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install", "elispdir=/usr/local/share/emacs/site-lisp"
  end

  test do
    system "#{bin}/pure", "--version"
  end
end
