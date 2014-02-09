require 'formula'

class YoutubeDl < Formula
  homepage 'http://rg3.github.io/youtube-dl/'
  url 'https://yt-dl.org/downloads/2014.02.08.2/youtube-dl-2014.02.08.2.tar.gz'
  sha1 'e0e66cd7a2d83b311b092fe4f22aa3f6f42fc6fb'

  def install
    system "make", "youtube-dl", "PREFIX=#{prefix}"
    bin.install 'youtube-dl'
    man1.install 'youtube-dl.1'
    bash_completion.install 'youtube-dl.bash-completion'
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg`."
  end

  def test
    system "#{bin}/youtube-dl", '--simulate', 'http://www.youtube.com/watch?v=he2a4xK8ctk'
  end
end
