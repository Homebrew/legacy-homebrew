require 'formula'

class Xmlstarlet < Formula
  url 'http://downloads.sourceforge.net/project/xmlstar/xmlstarlet/1.1.0/xmlstarlet-1.1.0.tar.gz'
  md5 '1b864b16c1dc78ce87ffc8528f021ab0'
  homepage 'http://xmlstar.sourceforge.net/'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--disable-dependency-tracking"
    # thanks, xmlstarlet but OS X doesn't have the static versions
    # easier to replace the resulting paths than to track configure madness
    # we know they are in /usr/lib because brew won't install libxml2 et al.
    inreplace 'Makefile' do |s|
      s.gsub! '/usr/lib/libxml2.a', '-lxml2'
      s.gsub! '/usr/lib/libxslt.a', '-lxslt'
      s.gsub! '/usr/lib/libexslt.a', '-lexslt'
      s.gsub! '-DLIBXML_STATIC', ''
    end
    system "make"
    system "make install"
  end
end
