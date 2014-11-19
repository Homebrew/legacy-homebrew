require 'formula'

class Moc < Formula
  homepage 'http://moc.daper.net'

  stable do
    url "http://ftp.daper.net/pub/soft/moc/stable/moc-2.5.0.tar.bz2"
  bottle do
    sha1 "1db850d8a502eb58a2f6f0f927b0f853a8964f62" => :mavericks
    sha1 "bf52427f83ca16498e5470f9d8bad9e5fd71c0f0" => :mountain_lion
    sha1 "4079ee34b2ce7f96cbe2830711a3569d65f7c600" => :lion
  end

    sha1 "a02c10075541995771dbdccb7f2d0ecd19d70b81"
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
