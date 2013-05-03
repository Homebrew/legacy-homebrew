require 'formula'

class Mp3fs < Formula
  homepage 'http://khenriks.github.io/mp3fs/'
  url 'https://github.com/downloads/khenriks/mp3fs/mp3fs-0.32.tar.gz'
  sha1 'e6aef12f753721c87bdecfb4dca7e3721a808828'

  depends_on 'pkg-config' => :build
  depends_on 'lame'
  depends_on 'fuse4x'
  depends_on 'libid3tag'
  depends_on 'flac'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    require 'open3'
    Open3.popen3("#{bin}/mp3fs", "-V") do |_, stdout, _|
      /MP3FS version #{Regexp.escape(version)}/ === stdout.read
    end
  end
end
