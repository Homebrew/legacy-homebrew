require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Matplotlib < Formula
  homepage 'http://matplotlib.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/matplotlib/matplotlib/matplotlib-1.1.0/matplotlib-1.1.0.tar.gz'
  sha1 '435b4f04a7e099b79f66451d69ad0b5ce66030ae'

  # deletion of an overloaded method creating a compilation error with clang++.
  def patches
    DATA
  end

  def install
    ENV.x11
    ENV.append "CFLAGS", "-I/usr/X11/include/freetype2"
    system "python setup.py config"
    system "python setup.py build"
    system "python setup.py install --prefix=#{prefix}"
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  def site_package_dir
    "lib/#{which_python}/site-packages"
  end

  def caveats
    <<-EOS
matplotlib Python modules have been linked to:
    #{HOMEBREW_PREFIX}/#{site_package_dir}

Make sure this folder is on your PYTHONPATH.
    EOS
  end

end

__END__
diff --git a/agg24/include/agg_renderer_outline_aa.h b/agg24/include/agg_renderer_outline_aa.h
index e3629db..30036c6 100644
--- a/agg24/include/agg_renderer_outline_aa.h
+++ b/agg24/include/agg_renderer_outline_aa.h
@@ -1365,7 +1365,7 @@ namespace agg
         //---------------------------------------------------------------------
         void profile(const line_profile_aa& prof) { m_profile = &prof; }
         const line_profile_aa& profile() const { return *m_profile; }
-        line_profile_aa& profile() { return *m_profile; }
+        //line_profile_aa& profile() { return *m_profile; }
 
         //---------------------------------------------------------------------
         int subpixel_width() const { return m_profile->subpixel_width(); }
