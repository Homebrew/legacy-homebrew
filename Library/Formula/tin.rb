class Tin < Formula
  homepage "http://www.tin.org"
  url "http://ftp.cuhk.edu.hk/pub/packages/news/tin/v2.2/tin-2.2.1.tar.gz"
  sha1 "9ef12345ed1cfb482138c5c54a7f73dfb91b9039"

  devel do
    url "http://ftp.cuhk.edu.hk/pub/packages/news/tin/v2.3/tin-2.3.1.tar.gz"
    sha1 "bee82da1e349a6a3954ab63d82a193e510aa1ff9"
  end

  conflicts_with "mutt", :because => "both install mmdf.5 and mbox.5 man pages"

  def install
    ENV.enable_warnings
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "build"
    system "make", "install"
  end

  test do
    system "#{bin}/tin", "-H"
  end
end
