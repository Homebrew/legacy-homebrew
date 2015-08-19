class Urlview < Formula
  desc "URL extractor/launcher"
  homepage "https://packages.debian.org/sid/misc/urlview"
  url "https://mirrors.kernel.org/debian/pool/main/u/urlview/urlview_0.9.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/u/urlview/urlview_0.9.orig.tar.gz"
  sha256 "746ff540ccf601645f500ee7743f443caf987d6380e61e5249fc15f7a455ed42"

  bottle do
    cellar :any
    sha256 "9ea616f456b9456d4b360a890de4b2c32252c6157d48f21e52d64865ed4ab983" => :yosemite
    sha256 "10083fe38ccf5e60d2a39d17ab9106b23905d4ff5fefc71b2e5f2bb50fa8cda7" => :mavericks
    sha256 "770efdc852305b834a843303ce28a37ed20cacc2afc37cf09c7e514d164fd668" => :mountain_lion
  end

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
