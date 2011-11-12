require 'formula'

class Herrie < Formula
  url 'http://herrie.info/distfiles/herrie-2.2.tar.bz2'
  homepage 'http://herrie.info/'
  md5 '88832b10298ab89473730eb0c93b6ddf'

  depends_on 'gettext' => :build
  depends_on 'glib'
  depends_on 'libvorbis'
  depends_on 'libid3tag'
  depends_on 'mad'
  depends_on 'libsndfile'

  def install
    ENV['PREFIX'] = prefix
    system "./configure no_modplug no_xspf coreaudio ncurses"
    system "make install"
  end
end
