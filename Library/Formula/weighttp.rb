require 'formula'

class Weighttp < Formula
  homepage 'http://redmine.lighttpd.net/projects/weighttp/wiki'
  url 'https://nodeload.github.com/lighttpd/weighttp/tar.gz/weighttp-0.3'
  sha1 '170b359abd989fe1db26c71e89dc07c3a7caaf05'
  head 'git://git.lighttpd.net/weighttp'

  depends_on 'libev'

  def install
    system "./waf", "configure"
    system "./waf", "build"
    system "./waf", "install"
  end

  def test
    system "weighttp -n 1 http://redmine.lighttpd.net/projects/weighttp/wiki"
  end
end
