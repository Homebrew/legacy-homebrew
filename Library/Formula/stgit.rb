require 'formula'

class Stgit < Formula
  homepage 'http://gna.org/projects/stgit/'
  url 'http://download.gna.org/stgit/stgit-0.17.1.tar.gz'
  sha256 'd43365a0c22e41a6fb9ba1a86de164d6475e79054e7f33805d6a829eb4056ade'

  head 'git://repo.or.cz/stgit.git'

  depends_on :python

  def install
    ENV['PYTHON'] = 'python' # overrides 'python2' built into makefile
    system "make", "prefix=#{prefix}", "all"
    system "make", "prefix=#{prefix}", "install"
  end
end
