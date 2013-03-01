require 'formula'

class Herrie < Formula
  homepage 'http://herrie.info/'
  url 'http://herrie.info/distfiles/herrie-2.2.tar.bz2'
  sha1 'ae5c39be11aeb19898cd3f968580eafc623830b7'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
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
