require 'formula'

class Dwdiff < Formula
  homepage 'http://os.ghalkes.nl/dwdiff.html'
  url 'http://os.ghalkes.nl/dist/dwdiff-2.0.4.tgz'
  sha1 '543a87f3de8c156d20b3ddf2bffd9331b7fb0575'

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
