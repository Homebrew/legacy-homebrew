require 'formula'

class Moc < Formula
  homepage 'http://moc.daper.net'
  url 'http://ftp.daper.net/pub/soft/moc/unstable/moc-2.5.0-beta1.tar.bz2'
  sha1 '4030a1fa5c7cfef06909c54d8c7a1fbb93f23caa'
  head 'svn://daper.net/moc/trunk'

  depends_on 'pkg-config' => :build
  depends_on 'gettext' => :build
  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'berkeley-db'
  depends_on 'jack'
  depends_on 'ffmpeg' => :recommended
  depends_on 'mad' => :optional
  depends_on 'flac' => :optional
  depends_on 'speex' => :optional
  depends_on 'musepack' => :optional
  depends_on 'libsndfile' => :optional
  depends_on 'wavpack' => :optional
  depends_on 'faad2' => :optional
  depends_on 'timidity' => :optional
  depends_on 'libmagic' => :optional
  depends_on 'ncurses' => :optional

  def patches
    # Patches up to r2544 (HEAD at 2013-08-13)
    { :p0 => 'https://gist.github.com/toroidal-code/6310844/raw/23c460144b64040eb6c3117693fd7e129a462b26/ffmpeg-patch.diff' }
  end unless build.head?


  def install
    system "autoreconf", "-i" # required to fix ffmpeg issues (updated ffmpeg.m4)
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<-EOS.undent
        The command to run moc is:
            mocp
        However, prior to this you must start the jack daemon with
            jackd -d coreaudio
        For info about automating this, see:
            https://gist.github.com/AzizLight/6045338
        If you need wide-character support in the player, for example
        with Chinese characters, you can install using
            --with-ncurses
    EOS
  end
end
