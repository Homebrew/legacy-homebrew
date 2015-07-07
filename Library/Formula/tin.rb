class Tin < Formula
  desc "Threaded, NNTP-, and spool-based UseNet newsreader"
  homepage "http://www.tin.org"
  url "http://ftp.cuhk.edu.hk/pub/packages/news/tin/v2.2/tin-2.2.1.tar.gz"
  sha1 "9ef12345ed1cfb482138c5c54a7f73dfb91b9039"

  bottle do
    sha1 "64bb6a1947bf0d5daf81d6dd1a964a555e5c618b" => :yosemite
    sha1 "960642645d2022d2f5568af56518b1d4633be1d0" => :mavericks
    sha1 "4ae3d6485d114bab7e0ff293bd11939e5fd76d12" => :mountain_lion
  end

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
