require 'formula'

class Xaw3d < Formula
  url 'ftp://ftp.visi.com/users/hawkeyd/X/Xaw3d-1.5E.tar.gz'
  homepage 'http://freshmeat.net/projects/xaw3d'
  md5 '29ecfdcd6bcf47f62ecfd672d31269a1'
  version '1.5E'

  depends_on 'imake'

  def install
    ENV.x11
    chdir 'lib/Xaw3d'
    inreplace 'Imakefile', 'XCOMM EXTRA_INCLUDES', 'EXTRA_INCLUDES'
    mkdir 'X11'
    chdir 'X11' do
      ln_s '..', 'Xaw3d'
    end

    system 'xmkmf'

    # force usage of /usr/X11/lib when linking, and install into the Cellar
    # apparently s.change_make_var! silently fails when Makefile variables
    # are preceded by whitespace, so do it manually
    inreplace 'Makefile', 'LDPRELIB = -L$(USRLIBDIR)', 'LDPRELIB = -L$(USRLIBDIR) $(LDFLAGS)'
    inreplace 'Makefile', 'USRLIBDIR = /usr/local/lib', "USRLIBDIR = #{lib}"
    inreplace 'Makefile', 'SHLIBDIR = /usr/local/lib', "SHLIBDIR = #{lib}"
    inreplace 'Makefile', 'INCROOT = /usr/local/include', "INCROOT = #{include}"

    system 'make'
    system 'make install'
  end
end
