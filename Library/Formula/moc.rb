require 'formula'

class Moc < Formula
  homepage 'http://moc.daper.net'

  stable do
    url "http://ftp.daper.net/pub/soft/moc/unstable/moc-2.5.0-beta1.tar.bz2"
    sha1 "4030a1fa5c7cfef06909c54d8c7a1fbb93f23caa"

    # Patches up to r2544 (HEAD at 2013-08-13)
    patch :p0 do
      url "https://gist.githubusercontent.com/toroidal-code/6310844/raw/23c460144b64040eb6c3117693fd7e129a462b26/ffmpeg-patch.diff"
      sha1 "55d64d17b320b391a5c11f502417fa8353498b37"
    end
  end

  head 'svn://daper.net/moc/trunk'

  option 'with-ncurses', 'Build with wide character support.'

  depends_on 'pkg-config' => :build
  depends_on 'gettext' => :build
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
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
  depends_on 'homebrew/dupes/ncurses' => :optional

  def install
    system "autoreconf", "-i" # required to fix ffmpeg issues (updated ffmpeg.m4)
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<-EOS.undent
        You must start the jack daemon prior to running mocp.
        If you need wide-character support in the player, for example
        with Chinese characters, you can install using
            --with-ncurses
    EOS
  end
end
