require 'formula'

class Pipebench < Formula
  homepage 'http://www.habets.pp.se/synscan/programs.php?prog=pipebench'
  url 'http://www.habets.pp.se/synscan/files/pipebench-0.40.tar.gz'
  sha1 '5ac405b9f1f25b39b3760fd9684533ccb778b26c'

  def install
    system "make"
    bin.install 'pipebench'
    man1.install 'pipebench.1'
  end

  test do
    system "#{bin}/pipebench", "-h"
  end
end
