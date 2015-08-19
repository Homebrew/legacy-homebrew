class Cppdom < Formula
  desc "C++ XML loader and writer with an internal DOM representation"
  homepage "http://sourceforge.net/projects/xml-cppdom/"
  url "https://downloads.sourceforge.net/project/xml-cppdom/CppDOM/1.2.0/cppdom-1.2.0.tar.bz2"
  sha256 "e4d8f25ef0fb67611d31c64d8f8055dcb69bbcaa805f2c1bcafa4cdc05115ff6"

  depends_on "scons" => :build
  depends_on "boost"

  # Don't install to prefix/lib64
  patch :DATA

  # Fix build failure by '#include <tr1/unordered_map>'
  # reported to upstream: https://sourceforge.net/p/xml-cppdom/patches/5/
  patch do
    url "https://sourceforge.net/p/xml-cppdom/patches/5/attachment/switch_tr1_header.diff"
    sha256 "47381550932e297222875d58c02155cce2f94e9caa2a48fe5c7fb6923a9bcd26"
  end

  # Workaround for multiple boost versions
  # reported to upstream: https://sourceforge.net/p/xml-cppdom/patches/6/
  patch do
    url "https://sourceforge.net/p/xml-cppdom/patches/6/attachment/boost_integration.diff"
    sha256 "f514ceb7b585931f2f47aefe483da2f01b3a466ad0d70de5f378548196229734"
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

