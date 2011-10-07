require 'formula'

class Xmlstarlet < Formula
  url 'http://downloads.sourceforge.net/project/xmlstar/xmlstarlet/1.1.0/xmlstarlet-1.1.0.tar.gz'
  md5 '1b864b16c1dc78ce87ffc8528f021ab0'
  homepage 'http://xmlstar.sourceforge.net/'

  def install
    # thanks, xmlstarlet but OS X doesn't have the static versions
    inreplace 'configure' do |s|
      s.gsub! '$LIBXML_LIBDIR/libxml2.a', '-lxml2'
      s.gsub! '$LIBXSLT_LIBDIR/libxslt.a', '-lxslt'
      s.gsub! '$LIBXSLT_LIBDIR/libexslt.a', '-lexslt'
    end

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end
