require 'formula'

class Stgit < Formula
  homepage 'http://gna.org/projects/stgit/'
  url 'http://download.gna.org/stgit/stgit-0.17.1.tar.gz'
  sha1 '5918fd983919ab70ab191868b84e917a06556cc2'

  head 'git://repo.or.cz/stgit.git'

  depends_on :python

  def install
    ENV['PYTHON'] = 'python' # overrides 'python2' built into makefile
    system "make", "prefix=#{prefix}", "all"
    system "make", "prefix=#{prefix}", "install"
  end
end
