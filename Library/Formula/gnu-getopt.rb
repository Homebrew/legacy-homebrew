require 'formula'

class GnuGetopt <Formula
  url 'http://software.frodo.looijaard.name/getopt/files/getopt-1.1.4.tar.gz'
  md5 '02188ca68da27c4175d6e9f3da732101'
  homepage 'http://software.frodo.looijaard.name/getopt/'

  depends_on 'gettext'

  def keg_only?
    :provided_by_osx
  end

  def install
    inreplace 'Makefile' do |s|
      gettext = Formula.factory 'gettext'
      s.change_make_var! "CPPFLAGS", "\\1 -I#{gettext.include}"
      s.change_make_var! "LDFLAGS", "\\1 -L#{gettext.lib} -lintl"
    end
    system "make", "prefix=#{prefix}", "mandir=#{man}", "install"
  end
end
