require 'formula'

class Xmlstarlet <Formula
  url 'http://downloads.sourceforge.net/project/xmlstar/xmlstarlet/1.0.3/xmlstarlet-1.0.3.tar.gz'
  md5 'ec9a39540b402affcb99a07f0a03d92a'
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
    inreplace 'src/Makefile' do |s|
      s.gsub! '/usr/lib/libxml2.a', '-lxml2'
      s.gsub! '/usr/lib/libxslt.a', '-lxslt'
      s.gsub! '/usr/lib/libexslt.a', '-lexslt'
      s.gsub! '-DLIBXML_STATIC', ''
    end
    system "make"
    system "make install"
  end
end
