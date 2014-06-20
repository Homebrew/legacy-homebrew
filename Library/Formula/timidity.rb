require 'formula'

class Timidity < Formula
  homepage 'http://timidity.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/timidity/TiMidity++/TiMidity++-2.14.0/TiMidity++-2.14.0.tar.bz2'
  sha1 '3d1d18ddf3e52412985af9a49dbe7ad345b478a8'

  option "without-darwin", "Build without Darwin CoreAudio support"
  option "without-freepats", "Build without the Freepats instrument patches from http://freepats.zenvoid.org/"

  depends_on 'libogg' => :recommended
  depends_on 'libvorbis' => :recommended
  depends_on 'flac' => :recommended
  depends_on 'speex' => :recommended

  resource 'freepats' do
    url 'http://freepats.zenvoid.org/freepats-20060219.zip'
    sha1 '8b798940dc581f025effead75428dfaaba356afe'
  end

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--mandir=#{man}"
           ]

    formats = []
    formats << 'darwin' if build.with? 'darwin'
    formats << 'vorbis' if build.with? 'libogg' and build.with? 'libvorbis'
    formats << 'flac' if build.with? 'flac'
    formats << 'speex' if build.with? 'speex'

    if formats.any?
      args << "--enable-audio=" + formats.join(",")
    end

    system "./configure", *args
    system "make install"

    if build.with? 'freepats'
      (share/'freepats').install resource('freepats')
      (share/'timidity').install_symlink share/'freepats/Tone_000',
                                         share/'freepats/Drum_000',
                                         share/'freepats/freepats.cfg' => 'timidity.cfg'
    end
  end

  test do
    system "#{bin}/timidity"
  end
end
