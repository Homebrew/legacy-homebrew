require 'formula'

class Ace < Formula
  url 'http://download.dre.vanderbilt.edu/previous_versions/ACE-6.0.2.tar.gz'
  homepage 'http://www.cse.wustl.edu/~schmidt/ACE.html'
  md5 '2c0f2f3e8401e180007c48ab139df720'

  # Default install target fails to pick up dylibs.
  # Next upstream release will fix this.
  # https://svn.dre.vanderbilt.edu/viewvc/MPC/trunk/prj_install.pl?r1=2012&r2=2011&pathrev=2012
  def patches
    { :p0 => DATA }
  end

  def install
    # ACE has two methods of compilation, "traditional" and ./configure.
    # The "traditional" method has consistently given better results
    # for the last 5 years, so although awkward to use on OSX, we use
    # it anyway.

    # First, we figure out the names of header files and make files
    # for this version of OSX.
    ver = %x[sw_vers -productVersion].chomp.split(".")
    ver = ver.slice(0).to_i*100 + ver.slice(1).to_i
    name = { 1002 => 'macosx', 1003 => 'macosx_panther',
             1004 => 'macosx_tiger', 1005 => 'macosx_leopard',
             1006 => 'macosx_snowleopard' }[ver]
    makefile = "platform_#{name}.GNU"
    header = "config-" + name.sub('_','-') + ".h"

    # Now, we give those files the appropriate standard names.
    ln_sf header, "ace/config.h"
    ln_sf makefile, "include/makeinclude/platform_macros.GNU"

    # Set up the environment the way ACE expects during build.
    root=Dir.pwd
    ENV['ACE_ROOT']=root
    ENV['DYLD_LIBRARY_PATH']="#{root}/ace:#{root}/lib"

    # Done! We go ahead and build.
    Dir.chdir "ace"
    system "make", "-f", "GNUmakefile.ACE", "INSTALL_PREFIX=#{prefix}",
       "LDFLAGS=", "DESTDIR=", "INST_DIR=/ace",
       "debug=0", "shared_libs=1", "static_libs=0", "install"
  end
end


__END__
--- MPC/prj_install-orig.pl     2011-04-05 17:54:16.000000000 -0400
+++ MPC/prj_install.pl  2011-04-05 17:53:26.000000000 -0400
@@ -186,7 +186,7 @@
     my $fh   = new FileHandle();
     if (opendir($fh, $odir)) {
       foreach my $file (grep(!/^\.\.?$/, readdir($fh))) {
-        if ($file =~ /^lib$name\.(a|so|sl)/ ||
+        if ($file =~ /^lib$name\.(a|so|sl|dylib)/ ||
             $file =~ /^(lib)?$name.*\.(dll|lib)$/i) {
           push(@libs, "$dir$insdir$binarydir$file");
         }