require 'formula'

class Xmlstarlet < Formula
  homepage 'http://xmlstar.sourceforge.net/'
  url 'http://sourceforge.net/projects/xmlstar/files/xmlstarlet/1.4.2/xmlstarlet-1.4.2.tar.gz'
  sha1 '432bd1bd2511369b7823e5731397744435a68f04'

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
