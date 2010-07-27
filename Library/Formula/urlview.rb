require 'formula'

class Urlview <Formula
  url 'http://ftp.de.debian.org/debian/pool/main/u/urlview/urlview_0.9.orig.tar.gz'
  homepage 'http://packages.debian.org/unstable/misc/urlview'
  md5 '67731f73e69297ffd106b65c8aebb2ab'

  def patches
    "http://ftp.de.debian.org/debian/pool/main/u/urlview/urlview_0.9-18.1.diff.gz"
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
