require 'formula'

class Pipebench < Formula
  homepage 'http://www.habets.pp.se/synscan/programs.php?prog=pipebench'
  url 'http://www.habets.pp.se/synscan/files/pipebench-0.40.tar.gz'
  md5 'eb1b888ec6c413c2cb096ac052174a78'

  def install
    system "make"
    bin.install 'pipebench'
    man1.install 'pipebench.1'
  end

  def test
    system "#{bin}/pipebench", "-h"
  end
end
