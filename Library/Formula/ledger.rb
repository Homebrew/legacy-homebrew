require 'formula'

class Ledger < Formula
  homepage 'http://ledger-cli.org'

  stable do
    url 'https://github.com/downloads/ledger/ledger/ledger-2.6.3.tar.gz'
    sha1 '5b8e7d8199acb116f13720a5a469fff1f14b4041'

    depends_on 'gettext'
    depends_on 'pcre'
    depends_on 'expat'
    depends_on 'libofx' => :optional
  end

  head do
    url 'https://github.com/ledger/ledger.git', :branch => 'master'
    depends_on 'cmake' => :build
    depends_on 'ninja' => :build
    depends_on 'mpfr'
  end

  option 'debug', 'Build with debugging symbols enabled'

  depends_on 'boost'
  depends_on 'gmp'
  depends_on :python => :optional

  # Fix HEAD to be compatible with Clang and libc++ on Mavericks.
  # See: http://article.gmane.org/gmane.comp.finance.ledger.general/5268
  if build.head? and MacOS.version >= :mavericks
    def patches; DATA end
  end

  def install
    opoo "Homebrew: Sorry, python bindings for --HEAD seem not to install. Help us fixing this!" if build.with? 'python'

    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    if build.head?
      args = [((build.include? 'debug') ? 'debug' : 'opt'), "make", "-N", "-j#{ENV.make_jobs}", "--output=build"]
      if build.with? 'python'
        args << '--python'
        # acprep picks up system python because CMake is used
        inreplace 'acprep', "self.configure_args  = []",
                            "self.configure_args  = ['-DPYTHON_INCLUDE_DIR=#{python.incdir}', '-DPYTHON_LIBRARY=#{python.libdir}/lib#{python.xy}.dylib']"
      end
      # Support homebrew not at /usr/local. Also support Xcode-only setups:
      inreplace 'acprep', 'search_prefixes = [', "search_prefixes = ['#{HOMEBREW_PREFIX}','#{MacOS.sdk_path}/usr',"
      system "./acprep", "--prefix=#{prefix}", *args
      system "cmake", "-P", "build/cmake_install.cmake", "-DUSE_PYTHON=ON"
    else
      args = []
      if build.with? 'libofx'
        args << "--enable-ofx"
        # the libofx.h appears to have moved to a subdirectory
        ENV.append 'CXXFLAGS', "-I#{Formula.factory('libofx').opt_prefix}/include/libofx"
      end
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}", *args
      system 'make'
      ENV.deparallelize
      system 'make install'
    end
  end
end

__END__
diff --git a/src/account.h b/src/account.h
index daeee03..b726fac 100644
--- a/src/account.h
+++ b/src/account.h
@@ -310,7 +310,7 @@ void put_account(property_tree::ptree& pt, const account_t& acct,

 //simple struct added to allow std::map to compare accounts in the accounts report
 struct account_compare {
-  bool operator() (const account_t& lhs, const account_t& rhs){
+  bool operator() (const account_t& lhs, const account_t& rhs) const {
     return (lhs.fullname().compare(rhs.fullname()) < 0);
   }
 };
diff --git a/src/commodity.h b/src/commodity.h
index a1988a3..d521d80 100644
--- a/src/commodity.h
+++ b/src/commodity.h
@@ -353,7 +353,7 @@ void put_commodity(property_tree::ptree& pt, const commodity_t& comm,

 //simple struct to allow std::map to compare commodities names
 struct commodity_compare {
-  bool operator() (const commodity_t* lhs, const commodity_t* rhs){
+  bool operator() (const commodity_t* lhs, const commodity_t* rhs) const {
     return (lhs->symbol().compare(rhs->symbol()) < 0);
   }
 };
