require 'formula'

class GtkChtheme < Formula
  homepage 'http://plasmasturm.org/code/gtk-chtheme/'
  url 'http://plasmasturm.org/code/gtk-chtheme/gtk-chtheme-0.3.1.tar.bz2'
  md5 'f688053bf26dd6c4f1cd0bf2ee33de2a'

  depends_on 'pkg-config' => :build
  depends_on 'cairo' 
  depends_on 'gdk-pixbuf' 
  depends_on 'gettext' 
  depends_on 'glib' 
  depends_on 'gtk+' 
  depends_on 'pango'

  def install
    # Unfortunately chtheme relies on some deprecated functionality
    # we need to disable errors for it to compile properly
    inreplace 'Makefile', '-DGTK_DISABLE_DEPRECATED', ''

#    inreplace 'Metadata' do |s|
#      s.change_make_var! "PREFIX", HOMEBREW_PREFIX
#    end
#    system "make install" # if this fails, try separate make/make install steps
    system "make", "PREFIX=#{prefix}", "install"
  end

end
