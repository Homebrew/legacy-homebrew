require 'formula'

class Csup < Formula
  homepage 'https://bitbucket.org/mux/csup'
  url 'https://bitbucket.org/mux/csup/get/REL_20120305.tar.gz'
  sha1 'caef119168723f1c1d6d32c0f2a1ac392df87afe'
  head 'https://bitbucket.org/mux/csup', :using => :hg

  def install
    system "make"
    bin.install "csup"
    man1.install "csup.1"
  end

  def test
    system "#{bin}/csup", "-v"
  end
end
