require 'formula'

class Xmlstarlet < Formula
  homepage 'http://xmlstar.sourceforge.net/'
  url 'http://sourceforge.net/projects/xmlstar/files/xmlstarlet/1.4.1/xmlstarlet-1.4.1.tar.gz'
  sha1 'dde6012a03d5421779a8f2b5a9ce632db23af017'

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
