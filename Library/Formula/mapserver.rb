class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "http://mapserver.org/"
  url "http://download.osgeo.org/mapserver/mapserver-6.2.2.tar.gz"
  sha256 "79b81286dde030704f59a668a19e5b01af27bb35d05b3daf91cefe06ca29ffd9"

  bottle do
    cellar :any
    sha256 "8bfa96a50ee83117bd929afc4ed1c6ce3e9e82a7e6da6328e4ca500c4fbb096d" => :yosemite
    sha256 "7ed6da72cbb724c1dfe92cc701bf292ddac02788dc7976f7a81e5e367b472262" => :mavericks
    sha256 "28b3fbf520436359a81d6b0a6875c30cb6f8bdb147ebc14f5860f7cf2c61ad47" => :mountain_lion
  end

  option "with-fastcgi", "Build with fastcgi support"
  option "with-geos", "Build support for GEOS spatial operations"
  option "with-php", "Build PHP MapScript module"
  option "with-postgresql", "Build support for PostgreSQL as a data source"

  env :userpaths

  depends_on "freetype"
  depends_on "libpng"
  depends_on "swig" => :build
  depends_on "giflib"
  depends_on "gd"
  depends_on "proj"
  depends_on "gdal"
  depends_on "geos" => :optional
  depends_on "postgresql" => :optional unless MacOS.version >= :lion
  depends_on "fcgi" if build.with? "fastcgi"
  depends_on "cairo" => :optional

  # This patch can be removed when this is merged https://github.com/mapserver/mapserver/pull/5113
  patch :DATA

  def install
    args = [
      "--prefix=#{prefix}",
      "--with-proj",
      "--with-gdal",
      "--with-ogr",
      "--with-wfs"
    ]

    args << "--with-geos" if build.with? "geos"
    args << "--with-php=/usr/bin/php-config" if build.with? "php"
    args << "--with-cairo" if build.with? "cairo"

    if build.with? "postgresql"
      if MacOS.version >= :lion # Lion ships with PostgreSQL libs
        args << "--with-postgis"
      else
        args << "--with-postgis=#{HOMEBREW_PREFIX}/bin/pg_config"
      end
    end

    args << "--with-fastcgi=#{HOMEBREW_PREFIX}" if build.with? "fastcgi"

    unless MacOS::CLT.installed?
      inreplace "configure", "_JTOPDIR=`echo \"$_ACJNI_FOLLOWED\" | sed -e 's://*:/:g' -e 's:/[^/]*$::'`",
                             "_JTOPDIR='#{MacOS.sdk_path}/System/Library/Frameworks/JavaVM.framework/Headers'"
    end

    system "./configure", *args
    system "make"

    install_args = []
    install_args << "PHP_EXT_DIR=#{prefix}" if build.with? "php"
    system "make", "install", *install_args

    cd "mapscript/python" do
      system "python", *Language::Python.setup_install_args(prefix)
    end
  end

  def caveats; <<-EOS.undent
    The Mapserver CGI executable is #{bin}/mapserv

    If you built the PHP option:
      * Add the following line to php.ini:
        extension="#{prefix}/php_mapscript.so"
      * Execute "php -m"
      * You should see MapScript in the module list
    EOS
  end

  test do
    system "#{bin}/mapserver-config", "--version"
  end
end

__END__
--- a/mapscript/python/setup.py	2015-06-28 17:43:34.000000000 +0200
+++ b/mapscript/python/setup.py	2015-06-28 17:47:16.000000000 +0200
@@ -32,6 +32,11 @@
 except ImportError:
     import popen2

+def update_dirs(list1, list2):
+    for v in list2:
+        if v not in list1 and os.path.isdir(v):
+            list1.append(v)
+
 #
 # # Function needed to make unique lists.
 def unique(list):
@@ -144,8 +149,12 @@
         return get_config(option, config =self.mapserver_config)

     def finalize_options(self):
+        if isinstance(self.include_dirs, str):
+            self.include_dirs = [path.strip() for path in self.include_dirs.strip().split(":")]
         if self.include_dirs is None:
             self.include_dirs = include_dirs
+
+        update_dirs(self.include_dirs, include_dirs)

         includes =  self.get_mapserver_config('includes')
         includes = includes.split()
@@ -154,9 +163,13 @@
                 if item[2:] not in include_dirs:
                     self.include_dirs.append( item[2:] )

+        if isinstance(self.library_dirs, str):
+            self.library_dirs = [path.strip() for path in self.library_dirs.strip().split(":")]
         if self.library_dirs is None:
             self.library_dirs = library_dirs

+        update_dirs(self.library_dirs, library_dirs)
+
         libs =  self.get_mapserver_config('libs')
         self.library_dirs = self.library_dirs + [x[2:] for x in libs.split() if x[:2] == "-L"]
