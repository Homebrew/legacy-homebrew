require 'formula'

class Vgmstream < Formula
  homepage 'http://hcs64.com/vgmstream.html'
  url 'https://vgmstream.svn.sourceforge.net/svnroot/vgmstream',
    :using => UnsafeSubversionDownloadStrategy, :revision => 982
  version 'r982'

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
