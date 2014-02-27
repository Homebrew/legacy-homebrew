require 'formula'

class Pplatex < Formula
  homepage 'http://www.stefant.org/web/projects/software/pplatex.html'
  url 'http://dl.dropbox.com/u/12697903/pplatex/pplatex-1.0-rc1-src.tar.gz'
  sha1 'd437c64a8263eeb45ded4f57df8cce29080a92d0'

  depends_on 'scons' => :build
  depends_on 'pcre'
  depends_on :tex

  def install
    scons "PCREPATH=#{Formula["pcre"].opt_prefix}"
    bin.install 'bin/pplatex', 'bin/ppdflatex'
  end

  test do
    system "#{bin}/pplatex", "-h"
  end
end
