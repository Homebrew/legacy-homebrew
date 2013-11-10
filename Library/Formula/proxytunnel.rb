require 'formula'

class Proxytunnel < Formula
  homepage 'http://proxytunnel.sourceforge.net/'
  url 'http://downloads.sourceforge.net/proxytunnel/proxytunnel-1.9.0.tgz'
  sha1 '51d816125bb9e9bca267d35f861000eb0fa9d80b'

  def install
    if MacOS.version >= :mavericks
      # http://trac.macports.org/browser/trunk/dports/net/proxytunnel/Portfile
      inreplace ["proxytunnel.h", "setproctitle.c", "strlcat.c", "strzcat.c"], "strlcat", "strlcat_disable"
      inreplace ["proxytunnel.h", "setproctitle.c", "strlcpy.c"], "strlcpy", "strlcpy_disable"
    end

    system "make"
    bin.install "proxytunnel"
    man1.install "proxytunnel.1"
  end
end
