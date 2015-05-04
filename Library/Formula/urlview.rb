class Urlview < Formula
  homepage "https://packages.debian.org/sid/misc/urlview"
  url "https://mirrors.kernel.org/debian/pool/main/u/urlview/urlview_0.9.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/u/urlview/urlview_0.9.orig.tar.gz"
  sha256 "746ff540ccf601645f500ee7743f443caf987d6380e61e5249fc15f7a455ed42"

  patch do
    url "https://mirrors.kernel.org/debian/pool/main/u/urlview/urlview_0.9-19.diff.gz"
    sha256 "056883c17756f849fb9235596d274fbc5bc0d944fcc072bdbb13d1e828301585"
  end

  def install
    inreplace "urlview.man", "/etc/urlview/url_handler.sh", "open"
    inreplace "urlview.c",
      '#define DEFAULT_COMMAND "/etc/urlview/url_handler.sh %s"',
      '#define DEFAULT_COMMAND "open %s"'

    man1.mkpath
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end
end
