require 'formula'

class Supertux < Formula
  homepage 'http://supertux.lethargik.org/'
  url 'http://download.berlios.de/supertux/supertux-0.1.3.tar.bz2'
  md5 'f2fc288459f33d5cd8f645fbca737a63'

  depends_on 'sdl'
  depends_on 'sdl_image'
  depends_on 'sdl_mixer'
  depends_on 'physfs'
  depends_on 'libogg'
  depends_on 'libvorbis'

  def patches
    # Patch from macports port
    # https://trac.macports.org/browser/trunk/dports/games/supertux/Portfile
    { :p0 => DATA }
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "supertux"
  end
end

__END__
--- src/menu.h.orig	2005-06-21 16:16:07.000000000 -0500
+++ src/menu.h	2011-08-29 03:28:39.000000000 -0500
@@ -207,7 +207,7 @@
 
   bool isToggled(int id);
 
-  void Menu::get_controlfield_key_into_input(MenuItem *item);
+  void get_controlfield_key_into_input(MenuItem *item);
 
   void draw   ();
   void draw_item(int index, int menu_width, int menu_height);

