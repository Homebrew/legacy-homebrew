require 'formula'

class YoutubeDl < Formula
  homepage 'http://rg3.github.io/youtube-dl/'
  url 'http://youtube-dl.org/downloads/2013.05.23/youtube-dl-2013.05.23.tar.gz'
  sha1 '68e70bf1f285536e84e4fdf71c3d27fefd830612'

  depends_on :python => :recommended
  depends_on :python3 => :optional

  def install
    python do
      system python, "setup.py", "install", "--prefix=#{prefix}",
                                            "--record=installed.txt",
                                            "--single-version-externally-managed"
      cp bin/'youtube-dl', bin/"youtube-dl#{python.version.major}"
    end
    bash_completion.install 'youtube-dl.bash-completion'
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg`."
  end
end
