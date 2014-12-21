require 'formula'

class Luabind < Formula
  homepage 'http://www.rasterbar.com/products/luabind.html'
  url 'https://downloads.sourceforge.net/project/luabind/luabind/0.9.1/luabind-0.9.1.tar.gz'
  sha1 '2e92a18b8156d2e2948951d429cd3482e7347550'
  revision 1

  depends_on 'lua51'
  depends_on 'boost'
  depends_on 'boost-build' => :build

  # boost 1.57 compatibility
  # https://github.com/Homebrew/homebrew/pull/33890#issuecomment-67723688
  # https://github.com/luabind/luabind/issues/27
  patch :DATA

  # patch Jamroot to perform lookup for shared objects with .dylib suffix
  patch do
    url "https://gist.githubusercontent.com/DennisOSRM/3728987/raw/052251fcdc23602770f6c543be9b3e12f0cac50a/Jamroot.diff"
    sha1 "5e7660e00e4189e42b8d79fbd2d6da21feb2259b"
  end

  # apply upstream commit to enable building with clang
  patch do
    url "https://github.com/luabind/luabind/commit/3044a9053ac50977684a75c4af42b2bddb853fad.diff"
    sha1 "49ecf2060a691abcdf4b3e07f1de450a2858f14f"
  end

  # include C header that is not pulled in automatically on OS X 10.9 anymore
  # submitted https://github.com/luabind/luabind/pull/20
  patch do
    url "https://gist.githubusercontent.com/DennisOSRM/a246514bf7d01631dda8/raw/0e83503dbf862ebfb6ac063338a6d7bca793f94d/object_rep.diff"
    sha1 "482693598edcde3d4c04fef3dfa35ea23f8e6bb4"
  end if MacOS.version >= :mavericks

  def install
    ENV["LUA_PATH"] = Formula["lua51"].opt_prefix
    args = [
      "release",
      "install",
    ]
    if ENV.compiler == :clang
      args << "--toolset=clang"
    elsif ENV.compiler == :llvm
      args << "--toolset=llvm"
    elsif ENV.compiler == :gcc
      args << "--toolset=darwin"
    end
    args << "--prefix=#{prefix}"
    system "bjam", *args
  end
end
__END__
diff --git a/luabind/object.hpp b/luabind/object.hpp
index f7b7ca5..5bb3fc3 100644
--- a/luabind/object.hpp
+++ b/luabind/object.hpp
@@ -536,6 +536,7 @@ namespace detail
       handle m_key;
   };
 
+#if BOOST_VERSION < 105700
 // Needed because of some strange ADL issues.
 
 #define LUABIND_OPERATOR_ADL_WKND(op) \\
@@ -557,6 +558,8 @@ namespace detail
   LUABIND_OPERATOR_ADL_WKND(!=)
 
 #undef LUABIND_OPERATOR_ADL_WKND
+
+#endif // BOOST_VERSION < 105700
  
 } // namespace detail
