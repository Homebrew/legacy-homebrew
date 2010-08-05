require 'formula'

class Dwdiff <Formula
  url 'http://os.ghalkes.nl/dist/dwdiff-1.8.1.tgz'
  homepage 'http://os.ghalkes.nl/dwdiff.html'
  md5 '37971be9e905aa3eeb4d494ad40a6318'

  # TODO: possibly set command line arguments to compile without the below
  # dependencies. Or set arguments to compile with and compile without by
  # default.
  depends_on 'gettext'
  depends_on 'icu4c'

  def install
    gettext_prefix = Formula.factory('gettext').prefix
    icu4c_prefix = Formula.factory('icu4c').prefix
    ENV.append "CFLAGS", "-I#{gettext_prefix}/include -I#{icu4c_prefix}/include"
    ENV.append "LDFLAGS", "-L#{gettext_prefix}/lib -L#{icu4c_prefix}/lib"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
