class Mimms < Formula
  desc "Mms stream downloader"
  homepage "http://savannah.nongnu.org/projects/mimms"
  url "https://launchpad.net/mimms/trunk/3.2.1/+download/mimms-3.2.1.tar.bz2"
  sha256 "92cd3e1800d8bd637268274196f6baec0d95aa8e709714093dd96ba8893c2354"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libmms"

  # Switch shared library loading to Mach-O naming convention (.dylib)
  # Matching upstream bug report: http://savannah.nongnu.org/bugs/?29684
  patch :DATA

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    system "python", "setup.py", "install", "--prefix=#{prefix}"
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/mimms", "--version"
  end
end

__END__
diff --git a/libmimms/libmms.py b/libmimms/libmms.py
index fb59207..ac42ba4 100644
--- a/libmimms/libmms.py
+++ b/libmimms/libmms.py
@@ -23,7 +23,7 @@ exposes the mmsx interface, since this one is the most flexible.
 
 from ctypes import *
 
-libmms = cdll.LoadLibrary("libmms.so.0")
+libmms = cdll.LoadLibrary("libmms.0.dylib")
 
 # opening and closing the stream
 libmms.mmsx_connect.argtypes = [c_void_p, c_void_p, c_char_p, c_int]
