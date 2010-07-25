require 'formula'

class YoutubeDl <Formula
  url 'http://bitbucket.org/rg3/youtube-dl/raw/02377503b545/youtube-dl'
  homepage 'http://bitbucket.org/rg3/youtube-dl/overview'
  md5 '50b22dee9387d9d9641366974f809fc3'
  version '2010.07.24'

  def install
    bin.install 'youtube-dl'
  end
end
