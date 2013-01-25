require 'formula'

class Vgmstream < Formula
  homepage 'http://hcs64.com/vgmstream.html'
  url 'https://vgmstream.svn.sourceforge.net/svnroot/vgmstream',
    :using => UnsafeSubversionDownloadStrategy, :revision => 1007
  version 'r1007'

  depends_on 'mpg123'
  depends_on 'libvorbis'

  def install
    cd "test" do
      system "make"
      bin.install "test" => "vgmstream"
      lib.install "../src/libvgmstream.a"
    end
  end
end
