require 'formula'

class GnuGetopt < Formula
  homepage 'http://software.frodo.looijaard.name/getopt/'
  url 'http://software.frodo.looijaard.name/getopt/files/getopt-1.1.4.tar.gz'
  sha1 '8b9b329b3a8f5d52c91c0381616ecbd1ba291486'

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
