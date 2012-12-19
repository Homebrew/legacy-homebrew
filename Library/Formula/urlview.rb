require 'formula'

class Urlview < Formula
  homepage 'http://packages.debian.org/unstable/misc/urlview'
  url 'http://mirrors.kernel.org/debian/pool/main/u/urlview/urlview_0.9.orig.tar.gz'
  mirror 'http://ftp.us.debian.org/debian/pool/main/u/urlview/urlview_0.9.orig.tar.gz'
  sha1 '323af9ba30ba87ec600531629f5dd84c720984b6'

  def patches
    "http://ftp.aarnet.edu.au/debian/pool/main/u/urlview/urlview_0.9-19.diff.gz"
  end

  def install
    inreplace 'urlview.man', '/etc/urlview/url_handler.sh', 'open'
    inreplace 'urlview.c',
      '#define DEFAULT_COMMAND "/etc/urlview/url_handler.sh %s"',
      '#define DEFAULT_COMMAND "open %s"'

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    man1.mkpath
    system "make install"
  end
end
