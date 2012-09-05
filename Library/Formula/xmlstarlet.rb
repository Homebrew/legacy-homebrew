require 'formula'

class Xmlstarlet < Formula
  homepage 'http://xmlstar.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/xmlstar/xmlstarlet/1.4.0/xmlstarlet-1.4.0.tar.gz'
  sha1 '8c0542c4978e43fb876f6671a786510aa5f544cf'

  def install
    # thanks, xmlstarlet but OS X doesn't have the static versions
    inreplace 'configure' do |s|
      s.gsub! '$LIBXML_LIBDIR/libxml2.a', '-lxml2'
      s.gsub! '$LIBXSLT_LIBDIR/libxslt.a', '-lxslt'
      s.gsub! '$LIBXSLT_LIBDIR/libexslt.a', '-lexslt'
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
