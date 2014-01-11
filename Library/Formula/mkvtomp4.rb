require 'formula'

class Mkvtomp4 < Formula
  homepage 'https://github.com/gavinbeatty/mkvtomp4/'
  url 'https://github.com/gavinbeatty/mkvtomp4/archive/mkvtomp4-v1.3.tar.gz'
  sha1 'eab345f40a2d6f30847300f8e2880354e08356d2'

  depends_on 'gpac'
  depends_on 'ffmpeg' => :recommended
  depends_on 'mkvtoolnix'
  depends_on :python

  def install
    system "make"
    system "python", "setup.py", "install", "--prefix=#{prefix}"
    mv bin/'mkvtomp4.py', bin/'mkvtomp4'
  end

  test do
    system "#{bin}/mkvtomp4", "--help"
  end
end
