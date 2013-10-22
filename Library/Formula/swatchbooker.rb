require 'formula'

class Swatchbooker < Formula
  homepage 'http://www.selapa.net/swatchbooker/'
  url 'http://launchpad.net/swatchbooker/trunk/0.7.3/+download/SwatchBooker-0.7.3.tar.gz'
  sha1 'fd2e46c278e762dc0c3ed69f824ab620773f153e'

  depends_on :python
  depends_on :python => ["PIL" => 'pillow']
  depends_on 'little-cms' => 'with-python'
  depends_on 'pyqt'

  def patches
    DATA
  end

  def install
    # Tell launching shell scipts where the python library is
    inreplace %w[data/swatchbooker data/sbconvert data/sbconvertor] do |s|
      s.gsub! "/usr/lib", "#{HOMEBREW_PREFIX}/lib"
    end

    python do
      system python, "setup.py", "install", "--prefix=#{prefix}"
    end
  end

  def caveats
    python.standard_caveats if python
  end

  def test
    system "#{bin}/swatchbooker"
  end
end

__END__
diff --git a/src/swatchbook/color.py b/src/swatchbook/color.py
index 48ae503..f3511a2 100644
--- a/src/swatchbook/color.py
+++ b/src/swatchbook/color.py
@@ -28,7 +28,7 @@ def dirpath(name):
	if not name:
		return name
	elif os.path.islink(name):
-		return os.path.dirname(os.path.abspath(os.path._resolve_link(name)))
+		return os.path.dirname(os.path.abspath(os.path.realpath(name)))
	else:
		return os.path.dirname(name)
