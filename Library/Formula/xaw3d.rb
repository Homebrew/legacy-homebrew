require 'formula'

class Xaw3d < Formula
  homepage 'http://freshmeat.net/projects/xaw3d'
  url 'ftp://ftp.visi.com/users/hawkeyd/X/Xaw3d-1.5E.tar.gz'
  md5 '29ecfdcd6bcf47f62ecfd672d31269a1'

  depends_on 'imake' => :build
  depends_on :x11

  def install
    inreplace 'lib/Xaw3d/Imakefile', 'XCOMM EXTRA_INCLUDES', 'EXTRA_INCLUDES'
    cd 'lib/Xaw3d' do
      mkdir 'X11' do
        # TODO - surely this symlink can be made without the cd
        ln_s '..', 'Xaw3d'
      end

      system 'xmkmf'

      # force usage of /usr/X11/lib when linking, and install into the Cellar
      # apparently s.change_make_var! silently fails when Makefile variables
      # are preceded by whitespace, so do it manually
      inreplace 'Makefile' do |s|
        s.gsub! 'LDPRELIB = -L$(USRLIBDIR)', 'LDPRELIB = -L$(USRLIBDIR) $(LDFLAGS)'
        s.gsub! 'USRLIBDIR = /usr/local/lib', "USRLIBDIR = #{lib}"
        s.gsub! 'SHLIBDIR = /usr/local/lib', "SHLIBDIR = #{lib}"
        s.gsub! 'INCROOT = /usr/local/include', "INCROOT = #{include}"
      end

      system 'make'
      system 'make install'
    end
  end
end
