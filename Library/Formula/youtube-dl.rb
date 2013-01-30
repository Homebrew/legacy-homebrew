require 'formula'

class YoutubeDl < Formula
  homepage 'http://rg3.github.com/youtube-dl/'
  url 'http://youtube-dl.org/downloads/2013.01.28/youtube-dl-2013.01.28.tar.gz'
  sha1 '91b0ead8ab2136e36c920a7a34f9085a792675f0'
  option 'use-python3', "Make youtube-dl use python3"

  def install
    args = []
    if build.include? 'use-python3' then
      args << '--always-make' #youtube-dl is already built with /usr/bin/env python
      args << 'PYTHON=/usr/bin/env python3'
    end
    system "make", "youtube-dl", "PREFIX=#{prefix}", *args
    bin.install 'youtube-dl'
    man1.install 'youtube-dl.1'
    (prefix+'etc/bash_completion.d').install 'youtube-dl.bash-completion'
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg`."
  end
end
