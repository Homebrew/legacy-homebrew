require 'formula'

class Xmlstarlet <Formula
  url 'http://downloads.sourceforge.net/project/xmlstar/xmlstarlet/1.0.5/xmlstarlet-1.0.5.tar.gz'
  md5 '2a7e5333051fb0b38647cd1e94e81050'
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
