require 'formula'

class Dao < Formula
  homepage 'http://daovm.net/'
  url 'http://sourceforge.net/projects/daoscript/files/dao-2.0-beta/dao-2.0-beta1-2013-05-28.tgz'
  version '2.0b1'
  sha1 '9bad11d8ef1dfd17ab5395c22b4c7638f1b808a0'

  def patches
    DATA # work around a bug in the module makefiles
  end

  def install
    ENV.j1 # parts of the build system seem to be bootstrapped, so parallel building is no good

    system "make", "-f", "Makefile.daomake", "macosx", "INSTALL=#{prefix}"
    system "make", "install"
  end

  test do
    system "dao", "-v"
  end
end

__END__
diff --git a/makefile.dao b/makefile.dao
index 36e9a7e..368a33e 100644
--- a/makefile.dao
+++ b/makefile.dao
@@ -32,6 +32,7 @@ daovm_doc_path = DaoMake::Option( "DOC-PATH", daovm_root_path + "/shared/dao" )
 #   path = daovm.GetPath( "PATH-NAME" )
 #
 daovm.ExportPath( "INSTALL-PATH", daovm_root_path );
+daovm.ExportPath( "ROOT-PATH", daovm_root_path ); # some of the module makefiles use this instead of INSTALL-PATH
 daovm.ExportPath( "BIN-PATH", daovm_bin_path );
 daovm.ExportPath( "LIB-PATH", daovm_lib_path );
 daovm.ExportPath( "MOD-PATH", daovm_mod_path );

