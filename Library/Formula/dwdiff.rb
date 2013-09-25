require 'formula'

class Dwdiff < Formula
  homepage 'http://os.ghalkes.nl/dwdiff.html'
  url 'http://os.ghalkes.nl/dist/dwdiff-2.0.7.tgz'
  sha1 '9e3a587c82d907e573a91ca931f8a1964ad8118a'

  depends_on 'gettext'
  depends_on 'icu4c'

  def install
    gettext = Formula.factory('gettext')
    icu4c = Formula.factory('icu4c')
    ENV.append "CFLAGS", "-I#{gettext.include} -I#{icu4c.include}"
    ENV.append "LDFLAGS", "-L#{gettext.lib} -L#{icu4c.lib}"
    system "./configure", "--prefix=#{prefix}"
    system "make install"

    # Remove non-English man pages
    (man+"nl").rmtree
    (man+"nl.UTF-8").rmtree
    (share+"locale/nl").rmtree
  end
end
