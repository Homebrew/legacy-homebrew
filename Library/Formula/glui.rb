require 'formula'

class Glui < Formula
  homepage 'http://glui.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/glui/Source/2.36/glui-2.36.tgz'
  sha256 'c1ef5e83cf338e225ce849f948170cd681c99661a5c2158b4074515926702787'

  # Fix compiler warnings in glui.h. Reported upstream:
  # http://sourceforge.net/p/glui/patches/12/
  patch :DATA

  def install
    cd 'src' do
      system 'make setup'
      system 'make lib/libglui.a'
      lib.install 'lib/libglui.a'
      include.install 'include/GL'
    end
  end
end

__END__
diff --git a/src/include/GL/glui.h b/src/include/GL/glui.h
index 01a5c75..5784e29 100644
--- a/src/include/GL/glui.h
+++ b/src/include/GL/glui.h
@@ -941,7 +941,7 @@ public:
         spacebar_mouse_click = true;    /* Does spacebar simulate a mouse click? */
         live_type      = GLUI_LIVE_NONE;
         text = "";
-        last_live_text == "";
+        last_live_text = "";
         live_inited    = false;
         collapsible    = false;
         is_open        = true;
