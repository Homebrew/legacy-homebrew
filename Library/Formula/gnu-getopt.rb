require 'formula'

class GnuGetopt < Formula
  homepage 'http://software.frodo.looijaard.name/getopt/'
  url 'http://software.frodo.looijaard.name/getopt/files/getopt-1.1.5.tar.gz'
  sha1 '9090eb46ac92f2fd2749ca4121e81aaad40f325d'

  bottle do
    sha1 "6eabcaf1e8a8942c7211279f4950ecd002a8600f" => :mavericks
    sha1 "68382964c9d56b44c8f149dcb2f7632809dff87d" => :mountain_lion
    sha1 "4a344addaaac7afef511d0fa29d9daaa32ed5b39" => :lion
  end

  depends_on 'gettext'

  keg_only :provided_by_osx

  def install
    inreplace 'Makefile' do |s|
      gettext = Formula['gettext']
      s.change_make_var! "CPPFLAGS", "\\1 -I#{gettext.include}"
      s.change_make_var! "LDFLAGS", "\\1 -L#{gettext.lib} -lintl"
    end
    system "make", "prefix=#{prefix}", "mandir=#{man}", "install"
  end
end
