require 'formula'

class Jemalloc < Formula
  homepage 'http://www.canonware.com/jemalloc/download.html'
  url 'http://www.canonware.com/download/jemalloc/jemalloc-3.5.0.tar.bz2'
  sha1 '3c6aeed5adbd7267ec7db476f002051143a43ac0'

  bottle do
    sha1 "3eae83e595a6140685008255b03549f7e5f73c7d" => :mavericks
    sha1 "00a2f95fe96f2dc85d6d1470e8685ca4c8a822d8" => :mountain_lion
    sha1 "73958a90f38b8bb5fd83d339106f4ef80d73337d" => :lion
  end

  def install
    system './configure', '--disable-debug', "--prefix=#{prefix}"
    system 'make install'

    # This otherwise conflicts with google-perftools
    mv "#{bin}/pprof", "#{bin}/jemalloc-pprof"
  end
end
