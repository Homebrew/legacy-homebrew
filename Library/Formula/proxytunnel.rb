require 'formula'

class Proxytunnel < Formula
  homepage 'http://proxytunnel.sourceforge.net/'
  url 'http://downloads.sourceforge.net/proxytunnel/proxytunnel-1.9.0.tgz'
  sha1 '51d816125bb9e9bca267d35f861000eb0fa9d80b'

  def install
    system "make"
    bin.install "proxytunnel"
    man1.install "proxytunnel.1"
  end
end
