require 'formula'

class Cppdom < Formula
  homepage 'http://sourceforge.net/projects/xml-cppdom/'
  url 'http://downloads.sourceforge.net/project/xml-cppdom/CppDOM/1.2.0/cppdom-1.2.0.tar.bz2'
  sha1 'cf3a20689e82b8907825ac9d0602f469f879d934'

  depends_on 'scons' => :build
  depends_on 'boost'

  # Don't install to prefix/lib64
  def patches; DATA; end

  def install
    args = ["prefix=#{prefix}", "build_test=no", "var_type=optimized",
      "BoostBaseDir=#{HOMEBREW_PREFIX}/"]

    if MacOS.prefer_64_bit?
      args << 'var_arch=x64'
    else
      args << 'var_arch=ia32'
    end

    system "#{HOMEBREW_PREFIX}/bin/scons", "install", *args
  end
end

__END__
diff --git a/SConstruct b/SConstruct
index ef38778..97a9ea3 100644
--- a/SConstruct
+++ b/SConstruct
@@ -170,9 +170,6 @@ if not SConsAddons.Util.hasHelpFlag():

       inst_paths = copy.copy(base_inst_paths)
       inst_paths['libPrefix'] = pj(inst_paths['flagpollPrefix'], 'lib')
-      if "x64" == combo["arch"]:
-         inst_paths['lib'] = inst_paths['lib'] + '64'
-         inst_paths['libPrefix'] = inst_paths['libPrefix'] + '64'
       if "debug" == combo["type"]:
          inst_paths["lib"] = pj(inst_paths["lib"],"debug")
          inst_paths['libPrefix'] = pj(inst_paths['libPrefix'],'debug')

