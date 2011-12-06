require 'formula'

class Vgmstream < Formula
  url 'https://vgmstream.svn.sourceforge.net/svnroot/vgmstream',
    :using => UnsafeSubversionDownloadStrategy, :revision => 968
  homepage 'http://hcs64.com/vgmstream.html'
  version 'r968'

  depends_on 'mpg123'
  depends_on 'libvorbis'

  def install
    Dir.chdir "test"
    system "make"
    bin.install "test" => "vgmstream"
    lib.install "../src/libvgmstream.a"
  end
end
