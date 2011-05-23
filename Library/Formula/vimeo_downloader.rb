require 'formula'

class VimeoDownloader < Formula
  url 'http://ossguy.com/video_hosts/vimeo_downloader.sh'
  homepage 'http://ossguy.com/?p=841'
  md5 '8aa9a45ad7b7b8f7f8e5369a5fc3d336'
  version '0.3.1'
  
  def install
    # prefix.install('vimeo_downloader.sh')
    # ln_s "#{prefix}/vimeo_downloader.sh", "#{bin}/vimeo_downloader"
    bin.install('vimeo_downloader.sh')
    system "mv #{bin}/vimeo_downloader.sh #{bin}/vimeo_downloader"
  end
end
