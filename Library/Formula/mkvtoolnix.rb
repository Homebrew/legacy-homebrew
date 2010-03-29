require 'formula'

class Mkvtoolnix <Formula
  url 'http://www.bunkus.org/videotools/mkvtoolnix/sources/mkvtoolnix-3.3.0.tar.bz2'
  homepage 'http://www.bunkus.org/videotools/mkvtoolnix/'
  md5 'a002b6537e4515b6a0b26f42e8a2eb9a'

  depends_on 'boost'
  depends_on 'libvorbis'
  depends_on 'libmatroska'
  depends_on 'flac' => :optional
  depends_on 'lzo' => :optional

  def install
    # as of v3.3.0, doesn't seem to be BSD compatible here
    inreplace 'handle_deps',
      %q!sed -e 's:\\.\\(o\\|gch\\)$:.d:'!,
      %q!sed -E -e 's:\\.(o|gch)$:.d:'!

    flac_flag = Formula.factory('flac').installed? ? "--with-flac" : "--without-flac"

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-boost-regex=boost_regex-mt", # via macports
                          flac_flag,
                          "--disable-gui", "--disable-wxwidgets"
    system "make"
    system "make install"
  end
end
