require 'formula'

class LibquviScripts < Formula
  url 'http://downloads.sourceforge.net/project/quvi/0.4/libquvi-scripts/libquvi-scripts-0.4.1.tar.bz2'
  sha1 '3415f6e5bd367450f2bb8cfd49b718ebbb0a7ebb'
  homepage 'http://quvi.sourceforge.net/'
end

class Libquvi < Formula
  url 'http://downloads.sourceforge.net/project/quvi/0.4/libquvi/libquvi-0.4.0.tar.bz2'
  sha1 '2effa310deef7049ed6dcf38e2ae6bf05a7689bf'
  homepage 'http://quvi.sourceforge.net/'

  depends_on 'lua'

  def install

    d = prefix + 'libquvi-scripts'
    LibquviScripts.new.brew do
      system "./configure", "--prefix=#{d}", "--with-nsfw"
      system "make install"
    end

    d = prefix + 'libquvi-scripts/lib/pkgconfig'
    ENV['PKG_CONFIG_PATH'] = d
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"

  end
end
