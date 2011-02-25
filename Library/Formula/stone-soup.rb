require 'formula'

class HeadDownloadStrategy <GitDownloadStrategy

  def stage
    stagedir= Dir.getwd
    Dir.chdir cached_location
    versiondir = Pathname.new("#{stagedir}/crawl-ref/source/util")
    versiondir.mkpath
    `git describe --tags --long > #{versiondir}/release_ver`
    Dir.chdir stagedir
    super
  end
end

class StoneSoup <Formula
  url 'http://sourceforge.net/projects/crawl-ref/files/Stone%20Soup/0.7.1/stone_soup-0.7.1.tar.bz2'
  homepage 'http://crawl.develz.org/wordpress/'
  md5 'e95e538264bbcf6db64cec920d669542'
  head 'git://gitorious.org/crawl/crawl.git', :branch => 'master', :using => HeadDownloadStrategy

  def install
    if ARGV.build_head?
      Dir.chdir "crawl-ref/source"
    else
      Dir.chdir "source"
    end
    system "make", "prefix=#{prefix}", "SAVEDIR=saves/", "DATADIR=data/", "install"
  end
end

