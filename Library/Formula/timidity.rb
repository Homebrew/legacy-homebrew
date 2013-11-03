require 'formula'

class Freepats < Formula
  homepage 'http://freepats.zenvoid.org/'
  url 'http://freepats.zenvoid.org/freepats-20060219.zip'
  sha1 '8b798940dc581f025effead75428dfaaba356afe'
end

class Timidity < Formula
  homepage 'http://timidity.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/timidity/TiMidity++/TiMidity++-2.14.0/TiMidity++-2.14.0.tar.bz2'
  sha1 '3d1d18ddf3e52412985af9a49dbe7ad345b478a8'

  option "without-darwin", "Build without Darwin CoreAudio support"
  option "without-freepats", "Build without the Freepats instrument patches from http://freepats.zenvoid.org/"

  depends_on 'libogg' => :recommended
  depends_on 'libvorbis' => :recommended
  depends_on 'flac' => :recommended
  depends_on 'speex' => :recommended

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--mandir=#{man}"
           ]

    formats = Array.new
    if !build.include? 'without-darwin'
      formats.push 'darwin'
    end
    if build.with? 'libogg' and build.with? 'libvorbis'
      formats.push 'vorbis'
    end
    if build.with? 'flac'
      formats.push 'flac'
    end
    if build.with? 'speex'
      formats.push 'speex'
    end
    if formats.any?
      args.push "--enable-audio=" + formats.join(",")
    end

    system "./configure", *args
    system "make install"

    if !build.include? 'without-freepats'
      Dir.mkdir share/'timidity'
      Freepats.new.brew do
         (share/'freepats').install Dir['*']
         File.symlink share/'freepats/freepats.cfg', share/'timidity/timidity.cfg'
         File.symlink share/'freepats/Tone_000', share/'timidity/Tone_000'
         File.symlink share/'freepats/Drum_000', share/'timidity/Drum_000'
      end
    end
  end

  test do
    system "#{bin}/timidity"
  end
end
