require 'formula'

class Dwdiff <Formula
  url 'http://os.ghalkes.nl/dist/dwdiff-1.8.2.tgz'
  homepage 'http://os.ghalkes.nl/dwdiff.html'
  md5 '3217486292ab4771f9bbc1097201a4e0'

  # TODO: possibly set command line arguments to compile without the below
  # dependencies. Or set arguments to compile with and compile without by
  # default.
  depends_on 'gettext'
  depends_on 'icu4c'

  def install
    gettext = Formula.factory('gettext')
    icu4c = Formula.factory('icu4c')
    ENV.append "CFLAGS", "-I#{gettext.include} -I#{icu4c.include}"
    ENV.append "LDFLAGS", "-L#{gettext.lib} -L#{icu4c.lib}"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
