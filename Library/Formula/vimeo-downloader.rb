require 'formula'

class VimeoDownloader < Formula
  url 'http://ossguy.com/video_hosts/vimeo_downloader.sh'
  homepage 'http://ossguy.com/?p=841'
  sha1 'd49792a22ec442fa0b3cf5f70d13793f342c6e26'
  version '0.3.1'

  def install
    bin.install 'vimeo_downloader.sh' => 'vimeo_downloader'
  end
end
