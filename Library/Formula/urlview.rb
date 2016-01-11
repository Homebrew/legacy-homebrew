class Urlview < Formula
  desc "URL extractor/launcher"
  homepage "https://packages.debian.org/sid/misc/urlview"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/u/urlview/urlview_0.9.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/u/urlview/urlview_0.9.orig.tar.gz"
  sha256 "746ff540ccf601645f500ee7743f443caf987d6380e61e5249fc15f7a455ed42"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "9dbd6e280b74de72eecfab8d51728bfe46fc6a02f22a5c2e6b1639b904680ebb" => :el_capitan
    sha256 "dfbc0ddbb5705383fda6175930cb57bbc5b124c31e9b4ec879d86b6211efe3d0" => :yosemite
    sha256 "5ece2167d692912f75c743425a9b0dc50d63863335b38c6ecb72175ab1bc7eb8" => :mavericks
  end

  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/u/urlview/urlview_0.9-19.diff.gz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/u/urlview/urlview_0.9-19.diff.gz"
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
