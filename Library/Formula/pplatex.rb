require 'formula'

class Pplatex < Formula
  homepage 'http://www.stefant.org/web/projects/software/pplatex.html'
  url 'http://dl.dropbox.com/u/12697903/pplatex/pplatex-1.0-rc1-src.tar.gz'
  sha1 'd437c64a8263eeb45ded4f57df8cce29080a92d0'

  depends_on 'scons' => :build
  depends_on 'pcre'

  def install
    system 'scons'
    bin.install 'bin/pplatex', 'bin/ppdflatex'
  end

  def test
    system "#{bin}/pplatex", "-h"
  end
end
