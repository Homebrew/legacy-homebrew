require 'formula'

class MpegStat < Formula
  url 'http://hpux.connect.org.uk/ftp/hpux/Development/Tools/mpeg_stat-2.2b/mpeg_stat-2.2b-src-11.00.tar.gz'
  homepage 'http://hpux.connect.org.uk/hppd/hpux/Development/Tools/mpeg_stat-2.2b/'
  version '2.2b-11.00'
  md5 'b836282185be404a6eebb55311b49ade'

  def patches
    # add a compliant install target
    "https://raw.github.com/gist/1065220/brew-install.patch"
  end

  def install
    system "make install DESTDIR=#{prefix}"
  end
end
