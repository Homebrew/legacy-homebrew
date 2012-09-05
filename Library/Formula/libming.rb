require 'formula'

class Libming < Formula
  homepage 'http://www.libming.org'
  url 'http://sourceforge.net/projects/ming/files/Releases/ming-0.4.4.tar.bz2'
  sha1 'e803b3b94a00a361e3415105f26112cf6f7bac81'

  option 'python', 'Build the python extension'
  option 'perl', 'Build the perl extension'
  option 'php', 'Build the php extension'

  depends_on :libpng
  depends_on :freetype
  depends_on 'giflib' => :optional

  # Helps us find libgif.dylib, not libungif.dylib which is retired.
  def patches
    DATA
  end

  def install
    # TODO: Libming also includes scripting front-ends for Perl, Python, TCL
    # and PHP.  These are disabled by default.  Figure out what it would take to
    # enable them.
    # - python works if we tell it to use our giflib not ungif.
    # - perl works without any change
    # - php builds, but tries to install to /usr/lib/php/extensions
    # - tcl does not work, might need an older tcl, missing symbols.
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]
    args << '--enable-python' if build.include? 'python'
    args << '--enable-perl' if build.include? 'perl'
    args << '--enable-php' if build.include? 'php'

    system './configure', *args
    system 'make'

    # Won't install in parallel for some reason.
    ENV.deparallelize
    system "make install"
  end
end

__END__
--- a/py_ext/setup.py.in	2011-10-25 23:33:18.000000000 -0700
+++ b/py_ext/setup.py.in	2012-09-04 13:39:52.000000000 -0700
@@ -19,7 +19,7 @@
 	mylibs.append('png')
 
 if "@GIFLIB@":
-	mylibs.append("ungif")
+	mylibs.append("gif")
 
 
 setup(name = "mingc", version = "@MING_VERSION@",
