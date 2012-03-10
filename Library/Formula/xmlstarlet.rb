require 'formula'

class Xmlstarlet < Formula
  homepage 'http://xmlstar.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/xmlstar/xmlstarlet/1.3.1/xmlstarlet-1.3.1.tar.gz'
  md5 '5173ad3f01ec0ba0d54bd1fbfc057abf'

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
