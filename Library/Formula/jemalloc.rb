require 'formula'

class Jemalloc < Formula
  homepage 'http://www.canonware.com/jemalloc/download.html'
  url 'http://www.canonware.com/download/jemalloc/jemalloc-3.3.1.tar.bz2'
  sha1 '75266cf0356bad309503d16080fecd61c67c66c0'

  def install
    system './configure', '--disable-debug', "--prefix=#{prefix}"
    system 'make install'

    # This otherwise conflicts with google-perftools
    mv "#{bin}/pprof", "#{bin}/jemalloc-pprof"
  end
end
