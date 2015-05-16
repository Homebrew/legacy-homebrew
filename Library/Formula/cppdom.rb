require "formula"

class Cppdom < Formula
  homepage "http://sourceforge.net/projects/xml-cppdom/"
  url "https://downloads.sourceforge.net/project/xml-cppdom/CppDOM/1.2.0/cppdom-1.2.0.tar.bz2"
  sha1 "cf3a20689e82b8907825ac9d0602f469f879d934"

  depends_on "scons" => :build
  depends_on "boost"

  # Don't install to prefix/lib64
  patch :DATA

  # Fix build failure by '#include <tr1/unordered_map>'
  # reported to upstream: https://sourceforge.net/p/xml-cppdom/patches/5/
  patch do
    url "https://sourceforge.net/p/xml-cppdom/patches/5/attachment/switch_tr1_header.diff"
    sha1 "a645006efc2e82478b5f7a1f0631f240a378b8a1"
  end

  # Workaround for multiple boost versions
  # reported to upstream: https://sourceforge.net/p/xml-cppdom/patches/6/
  patch do
    url "https://sourceforge.net/p/xml-cppdom/patches/6/attachment/boost_integration.diff"
    sha1 "e0c6a0d0cfe07317e343e3334e922213db2ea6b8"
  end

  def install
    args = ["prefix=#{prefix}", "build_test=no", "var_type=optimized",
      "BoostBaseDir=#{HOMEBREW_PREFIX}/"]

    if MacOS.prefer_64_bit?
      args << "var_arch=x64"
    else
      args << "var_arch=ia32"
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

