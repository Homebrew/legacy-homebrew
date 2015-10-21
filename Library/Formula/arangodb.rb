class Arangodb < Formula
  desc "Universal open-source database with a flexible data model"
  homepage "https://www.arangodb.com/"
  url "https://www.arangodb.com/repositories/Source/ArangoDB-2.7.0.tar.gz"
  sha256 "67fc1b0cb75e9ebf9857b30f54805283461161611865c8b343adcec8bb6060ed"

  head "https://github.com/arangodb/arangodb.git", :branch => "unstable"

  bottle do
    sha256 "a852b207a9c663c1b4903a76bf437c2a83422fb27d2d93af5e937aac119290a9" => :el_capitan
    sha256 "1ead12d5e6564047bd1c9768523740ed2fc04bf30f42ab7e0ded116043e17b24" => :yosemite
    sha256 "ac672a3d934e92923dd7c72e5c0422f9f3fc778302f62662c7b2bd35875b90af" => :mavericks
  end

  depends_on "go" => :build
  depends_on "openssl"
  depends_on "readline"

  needs :cxx11

  # GCC 5 no longer supports the --stdlib options. This patch checks
  # if the option is available or not. It will be part of ArangoDB 2.7.1
  # in which case the patch can be removed again
  patch :DATA

  fails_with :clang do
    build 600
    cause "Fails with compile errors"
  end

  def install
    # clang on 10.8 will still try to build against libstdc++,
    # which fails because it doesn't have the C++0x features
    # arangodb requires.
    ENV.libcxx

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-relative
      --datadir=#{share}
      --localstatedir=#{var}
    ]

    args << "--program-suffix=-unstable" if build.head?

    system "./configure", *args
    system "make", "install"

    (var/"arangodb").mkpath
    (var/"log/arangodb").mkpath
  end

  def post_install
    system "#{sbin}/arangod" + (build.head? ? "-unstable" : ""), "--upgrade", "--log.file", "-"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/arangodb/sbin/arangod" + (build.head? ? "-unstable" : "") + " --log.file -"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/arangod</string>
          <string>-c</string>
          <string>#{etc}/arangodb/arangod.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end
end
__END__
diff --git a/3rdParty/Makefile.v8 b/3rdParty/Makefile.v8
index 38238ea..0b0d210 100644
--- a/3rdParty/Makefile.v8
+++ b/3rdParty/Makefile.v8
@@ -20,6 +20,12 @@ GOLD_V8_FLAGS =
 GOLD_V8_GYP = -Dlinux_use_bundled_gold=0 -Dlinux_use_gold_flags=0
 endif

+if CXX_HAS_STDLIB
+STDLIB_FLAGS = -stdlib=libc++
+else
+STDLIB_FLAGS =
+endif
+
 V8DIR=@V8_DIR@

 @V8_LIBS@: @srcdir@/.v8-build-@TRI_BITS@
@@ -116,8 +122,8 @@ if ENABLE_V8_DEBUG
		CXX.host="$(CXX)" \
		LINK="$(CXX)" \
		LDFLAGS="-lc++" \
-		CFLAGS="-O0 -ggdb $(DEBUG_V8_FLAGS) $(GOLD_V8_FLAGS) -stdlib=libc++" \
-		CXXFLAGS="-O0 -ggdb $(DEBUG_V8_FLAGS) $(GOLD_V8_FLAGS) -stdlib=libc++" \
+		CFLAGS="-O0 -ggdb $(DEBUG_V8_FLAGS) $(GOLD_V8_FLAGS) $(CXX_HAS_STDLIB)" \
+		CXXFLAGS="-O0 -ggdb $(DEBUG_V8_FLAGS) $(GOLD_V8_FLAGS) $(CXX_HAS_STDLIB)" \
		debug=on v8_optimized_debug=0 v8_enable_backtrace=on \
		library=static strictaliasing=off snapshot=off werror=no @V8_TARGET@

@@ -135,8 +141,8 @@ else # ! ENABLE_V8_DEBUG
		CXX.host="$(CXX)" \
		LINK="$(CXX)" \
		LDFLAGS="-lc++" \
-		CFLAGS="-O3 -fomit-frame-pointer -g $(GOLD_V8_FLAGS) -stdlib=libc++" \
-		CXXFLAGS="-O3 -fomit-frame-pointer -g $(GOLD_V8_FLAGS) -stdlib=libc++" \
+		CFLAGS="-O3 -fomit-frame-pointer -g $(GOLD_V8_FLAGS) $(CXX_HAS_STDLIB)" \
+		CXXFLAGS="-O3 -fomit-frame-pointer -g $(GOLD_V8_FLAGS) $(CXX_HAS_STDLIB)" \
		library=static strictaliasing=off snapshot=off werror=no @V8_TARGET@
 endif # ENABLE_V8_DEBUG

diff --git a/Makefile.in b/Makefile.in
index 7a92f1b..2eb95e0 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -2055,6 +2055,8 @@ DEBUG_V8_FLAGS = -DV8_TARGET_ARCH_X64 -DENABLE_GDB_JIT_INTERFACE -DV8_DEPRECATIO
 @ENABLE_GOLD_TRUE@GOLD_V8_FLAGS = -fuse-ld=gold
 @ENABLE_GOLD_FALSE@GOLD_V8_GYP = -Dlinux_use_bundled_gold=0 -Dlinux_use_gold_flags=0
 @ENABLE_GOLD_TRUE@GOLD_V8_GYP =
+@CXX_HAS_STDLIB_FALSE@STDLIB_FLAGS =
+@CXX_HAS_STDLIB_TRUE@STDLIB_FLAGS = -stdlib=libc++
 V8DIR = @V8_DIR@
 all: $(BUILT_SOURCES)
	$(MAKE) $(AM_MAKEFLAGS) all-am
@@ -10625,8 +10627,8 @@ clean-libev:
 @ENABLE_ARMV6_FALSE@@ENABLE_ARMV7_FALSE@@ENABLE_DARWIN_TRUE@@ENABLE_V8_DEBUG_TRUE@		CXX.host="$(CXX)" \
 @ENABLE_ARMV6_FALSE@@ENABLE_ARMV7_FALSE@@ENABLE_DARWIN_TRUE@@ENABLE_V8_DEBUG_TRUE@		LINK="$(CXX)" \
 @ENABLE_ARMV6_FALSE@@ENABLE_ARMV7_FALSE@@ENABLE_DARWIN_TRUE@@ENABLE_V8_DEBUG_TRUE@		LDFLAGS="-lc++" \
-@ENABLE_ARMV6_FALSE@@ENABLE_ARMV7_FALSE@@ENABLE_DARWIN_TRUE@@ENABLE_V8_DEBUG_TRUE@		CFLAGS="-O0 -ggdb $(DEBUG_V8_FLAGS) $(GOLD_V8_FLAGS) -stdlib=libc++" \
-@ENABLE_ARMV6_FALSE@@ENABLE_ARMV7_FALSE@@ENABLE_DARWIN_TRUE@@ENABLE_V8_DEBUG_TRUE@		CXXFLAGS="-O0 -ggdb $(DEBUG_V8_FLAGS) $(GOLD_V8_FLAGS) -stdlib=libc++" \
+@ENABLE_ARMV6_FALSE@@ENABLE_ARMV7_FALSE@@ENABLE_DARWIN_TRUE@@ENABLE_V8_DEBUG_TRUE@		CFLAGS="-O0 -ggdb $(DEBUG_V8_FLAGS) $(GOLD_V8_FLAGS) $(CXX_HAS_STDLIB)" \
+@ENABLE_ARMV6_FALSE@@ENABLE_ARMV7_FALSE@@ENABLE_DARWIN_TRUE@@ENABLE_V8_DEBUG_TRUE@		CXXFLAGS="-O0 -ggdb $(DEBUG_V8_FLAGS) $(GOLD_V8_FLAGS) $(CXX_HAS_STDLIB)" \
 @ENABLE_ARMV6_FALSE@@ENABLE_ARMV7_FALSE@@ENABLE_DARWIN_TRUE@@ENABLE_V8_DEBUG_TRUE@		debug=on v8_optimized_debug=0 v8_enable_backtrace=on \
 @ENABLE_ARMV6_FALSE@@ENABLE_ARMV7_FALSE@@ENABLE_DARWIN_TRUE@@ENABLE_V8_DEBUG_TRUE@		library=static strictaliasing=off snapshot=off werror=no @V8_TARGET@

@@ -10642,8 +10644,8 @@ clean-libev:
 @ENABLE_ARMV6_FALSE@@ENABLE_ARMV7_FALSE@@ENABLE_DARWIN_TRUE@@ENABLE_V8_DEBUG_FALSE@		CXX.host="$(CXX)" \
 @ENABLE_ARMV6_FALSE@@ENABLE_ARMV7_FALSE@@ENABLE_DARWIN_TRUE@@ENABLE_V8_DEBUG_FALSE@		LINK="$(CXX)" \
 @ENABLE_ARMV6_FALSE@@ENABLE_ARMV7_FALSE@@ENABLE_DARWIN_TRUE@@ENABLE_V8_DEBUG_FALSE@		LDFLAGS="-lc++" \
-@ENABLE_ARMV6_FALSE@@ENABLE_ARMV7_FALSE@@ENABLE_DARWIN_TRUE@@ENABLE_V8_DEBUG_FALSE@		CFLAGS="-O3 -fomit-frame-pointer -g $(GOLD_V8_FLAGS) -stdlib=libc++" \
-@ENABLE_ARMV6_FALSE@@ENABLE_ARMV7_FALSE@@ENABLE_DARWIN_TRUE@@ENABLE_V8_DEBUG_FALSE@		CXXFLAGS="-O3 -fomit-frame-pointer -g $(GOLD_V8_FLAGS) -stdlib=libc++" \
+@ENABLE_ARMV6_FALSE@@ENABLE_ARMV7_FALSE@@ENABLE_DARWIN_TRUE@@ENABLE_V8_DEBUG_FALSE@		CFLAGS="-O3 -fomit-frame-pointer -g $(GOLD_V8_FLAGS) $(CXX_HAS_STDLIB)" \
+@ENABLE_ARMV6_FALSE@@ENABLE_ARMV7_FALSE@@ENABLE_DARWIN_TRUE@@ENABLE_V8_DEBUG_FALSE@		CXXFLAGS="-O3 -fomit-frame-pointer -g $(GOLD_V8_FLAGS) $(CXX_HAS_STDLIB)" \
 @ENABLE_ARMV6_FALSE@@ENABLE_ARMV7_FALSE@@ENABLE_DARWIN_TRUE@@ENABLE_V8_DEBUG_FALSE@		library=static strictaliasing=off snapshot=off werror=no @V8_TARGET@

 ################################################################################
diff --git a/configure b/configure
index 2e441b1..ae0dbb5 100755
--- a/configure
+++ b/configure
@@ -700,6 +700,8 @@ ENABLE_LOGGER_TRUE
 RANLIB
 ENABLE_GOLD_FALSE
 ENABLE_GOLD_TRUE
+CXX_HAS_STDLIB_FALSE
+CXX_HAS_STDLIB_TRUE
 HAVE_CXX11
 LN_S
 CPP
@@ -5686,6 +5688,25 @@ if test x$GCC == xyes;  then

   if test x$tr_DARWIN == xyes;  then
     WALL="${WALL} -Wno-deprecated-declarations"
+
+
+
+    { $as_echo "$as_me:${as_lineno-$LINENO}: checking -stdlib=libc++ for $CXX" >&5
+$as_echo_n "checking -stdlib=libc++ for $CXX... " >&6; }
+          if { ac_try='${CXX} -Werror -stdlib=libc++ -xc++ /dev/null -S -o /dev/null'
+  { { eval echo "\"\$as_me\":${as_lineno-$LINENO}: \"$ac_try\""; } >&5
+  (eval $ac_try) 2>&5
+  ac_status=$?
+  $as_echo "$as_me:${as_lineno-$LINENO}: \$? = $ac_status" >&5
+  test $ac_status = 0; }; }; then :
+  { $as_echo "$as_me:${as_lineno-$LINENO}: result: yes" >&5
+$as_echo "yes" >&6; }
+                tr_CXX_HAS_STDLIB="yes"
+else
+  { $as_echo "$as_me:${as_lineno-$LINENO}: result: no" >&5
+$as_echo "no" >&6; }
+                tr_CXX_HAS_STDLIB="no"
+fi
   fi

   WALLC="${WALL} -Wshadow -Wstrict-prototypes -Wdeclaration-after-statement"
@@ -5791,6 +5812,15 @@ fi
   CXXFLAGS="${GXXSTD} ${CXXFLAGS} ${WALLCXX}"
 fi

+ if test "x$tr_CXX_HAS_STDLIB" = "yes"; then
+  CXX_HAS_STDLIB_TRUE=
+  CXX_HAS_STDLIB_FALSE='#'
+else
+  CXX_HAS_STDLIB_TRUE='#'
+  CXX_HAS_STDLIB_FALSE=
+fi
+
+

 # Check whether --enable-isystem was given.
 if test "${enable_isystem+set}" = set; then :
@@ -8809,6 +8839,10 @@ if test -z "${am__fastdepCXX_TRUE}" && test -z "${am__fastdepCXX_FALSE}"; then
   as_fn_error $? "conditional \"am__fastdepCXX\" was never defined.
 Usually this means the macro was only invoked conditionally." "$LINENO" 5
 fi
+if test -z "${CXX_HAS_STDLIB_TRUE}" && test -z "${CXX_HAS_STDLIB_FALSE}"; then
+  as_fn_error $? "conditional \"CXX_HAS_STDLIB\" was never defined.
+Usually this means the macro was only invoked conditionally." "$LINENO" 5
+fi
 if test -z "${ENABLE_GOLD_TRUE}" && test -z "${ENABLE_GOLD_FALSE}"; then
   as_fn_error $? "conditional \"ENABLE_GOLD\" was never defined.
 Usually this means the macro was only invoked conditionally." "$LINENO" 5
diff --git a/m4/configure.basics b/m4/configure.basics
index 316a49d..4ef3555 100644
--- a/m4/configure.basics
+++ b/m4/configure.basics
@@ -174,6 +174,12 @@ if test x$GCC == xyes;  then

   if test x$tr_DARWIN == xyes;  then
     WALL="${WALL} -Wno-deprecated-declarations"
+
+
+
+    TRI_TRY_CXX_OPTION([-stdlib=libc++],
+                       [tr_CXX_HAS_STDLIB="yes"],
+                       [tr_CXX_HAS_STDLIB="no"])
   fi

   WALLC="${WALL} -Wshadow -Wstrict-prototypes -Wdeclaration-after-statement"
@@ -210,6 +216,8 @@ if test x$GCC == xyes;  then
   CXXFLAGS="${GXXSTD} ${CXXFLAGS} ${WALLCXX}"
 fi

+AM_CONDITIONAL(CXX_HAS_STDLIB, test "x$tr_CXX_HAS_STDLIB" = "yes")
+
 dnl ----------------------------------------------------------------------------
 dnl option for gnu style include
 dnl ----------------------------------------------------------------------------
