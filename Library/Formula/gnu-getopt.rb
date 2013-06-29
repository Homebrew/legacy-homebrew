require 'formula'

class GnuGetopt < Formula
  homepage 'http://software.frodo.looijaard.name/getopt/'
  url 'http://software.frodo.looijaard.name/getopt/files/getopt-1.1.5.tar.gz'
  sha1 '9090eb46ac92f2fd2749ca4121e81aaad40f325d'

  depends_on 'gettext'

  keg_only :provided_by_osx

  def install
    inreplace 'Makefile' do |s|
      gettext = Formula.factory 'gettext'
      s.change_make_var! "CPPFLAGS", "\\1 -I#{gettext.include}"
      s.change_make_var! "LDFLAGS", "\\1 -L#{gettext.lib} -lintl"
    end
    system "make", "prefix=#{prefix}", "mandir=#{man}", "install"
  end
end
