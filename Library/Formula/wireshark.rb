class Wireshark < Formula
  desc "Graphical network analyzer and capture tool"
  homepage "https://www.wireshark.org"

  stable do
    url "https://www.wireshark.org/download/src/all-versions/wireshark-1.12.8.tar.bz2"
    mirror "https://1.eu.dl.wireshark.org/src/wireshark-1.12.8.tar.bz2"
    sha256 "357e0a4e49525d80cdc740bb16539fcdb526ad38cc2ed6cabedafc9bdee5c7e7"

    # Removes SDK checks that prevent the build from working on CLT-only systems
    # Reported upstream: https://bugs.wireshark.org/bugzilla/show_bug.cgi?id=9290
    patch :DATA

    depends_on "homebrew/dupes/libpcap" => :optional
  end

  bottle do
    sha256 "011b9c1f55fdb42223af49b7bec04f387d5dd89d5b8a600faecca2011b776f08" => :el_capitan
    sha256 "2db41f691c2700bcb8bd20141671b279298cf65049966601f7d6ee96b4496482" => :yosemite
    sha256 "7980680d82cb4c3bf01c6b8c1f3970767773d9a09d5573e3ba418fe08f224bb4" => :mavericks
  end

  devel do
    url "https://www.wireshark.org/download/src/all-versions/wireshark-2.0.0rc2.tar.bz2"
    mirror "https://1.eu.dl.wireshark.org/src/wireshark-2.0.0rc2.tar.bz2"
    sha256 "b1d2139bd1e1b008337546059beece59e24387e7b96c3d691203f0ce1881b6c8"

    depends_on "homebrew/dupes/libpcap" if MacOS.version == :mavericks
  end

  head do
    url "https://code.wireshark.org/review/wireshark", :using => :git

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-gtk+3", "Build the wireshark command with gtk+3"
  option "with-gtk+", "Build the wireshark command with gtk+"
  option "with-qt", "Build the wireshark-qt command (can be used with or without either GTK option)"
  option "with-qt5", "Build the wireshark-qt command with qt5 (can be used with or without either GTK option)"
  option "with-headers", "Install Wireshark library headers for plug-in development"

  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "d-bus"

  depends_on "geoip" => :recommended
  depends_on "c-ares" => :recommended

  depends_on "libsmi" => :optional
  depends_on "lua" => :optional
  depends_on "portaudio" => :optional
  depends_on "qt5" => :optional
  depends_on "qt" => :optional
  depends_on "gtk+3" => :optional
  depends_on "gtk+" => :optional
  depends_on "gnome-icon-theme" if build.with? "gtk+3"

  def install
    no_gui = build.without?("gtk+3") && build.without?("qt") && build.without?("gtk+") && build.without?("qt5")

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-gnutls
    ]

    args << "--disable-wireshark" if no_gui
    args << "--disable-gtktest" if build.without?("gtk+3") && build.without?("gtk+")
    args << "--with-gtk3" if build.with? "gtk+3"
    args << "--with-gtk2" if build.with? "gtk+"
    args << "--with-libcap=#{Formula["libpcap"].opt_prefix}" if build.with? "libpcap"

    if build.with?("qt") || build.with?("qt5")
      args << "--with-qt"
    else
      args << "--with-qt=no"
    end

    if build.head?
      args << "--disable-warnings-as-errors"
      system "./autogen.sh"
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize # parallel install fails
    system "make", "install"

    if build.with? "headers"
      (include/"wireshark").install Dir["*.h"]
      (include/"wireshark/epan").install Dir["epan/*.h"]
      (include/"wireshark/epan/crypt").install Dir["epan/crypt/*.h"]
      (include/"wireshark/epan/dfilter").install Dir["epan/dfilter/*.h"]
      (include/"wireshark/epan/dissectors").install Dir["epan/dissectors/*.h"]
      (include/"wireshark/epan/ftypes").install Dir["epan/ftypes/*.h"]
      (include/"wireshark/epan/wmem").install Dir["epan/wmem/*.h"]
      (include/"wireshark/wiretap").install Dir["wiretap/*.h"]
      (include/"wireshark/wsutil").install Dir["wsutil/*.h"]
    end
  end

  def caveats; <<-EOS.undent
    If your list of available capture interfaces is empty
    (default OS X behavior), try the following commands:

      curl https://bugs.wireshark.org/bugzilla/attachment.cgi?id=3373 -o ChmodBPF.tar.gz
      tar zxvf ChmodBPF.tar.gz
      open ChmodBPF/Install\\ ChmodBPF.app

    This adds a launch daemon that changes the permissions of your BPF
    devices so that all users in the 'admin' group - all users with
    'Allow user to administer this computer' turned on - have both read
    and write access to those devices.

    See bug report:
      https://bugs.wireshark.org/bugzilla/show_bug.cgi?id=3760
    EOS
  end

  test do
    system bin/"randpkt", "-b", "100", "-c", "2", "capture.pcap"
    output = shell_output("#{bin}/capinfos -Tmc capture.pcap")
    assert_equal "File name,Number of packets\ncapture.pcap,2\n", output
  end
end

__END__
diff --git a/configure b/configure
index cd41b63..c473fe7 100755
--- a/configure
+++ b/configure
@@ -16703,42 +16703,12 @@ $as_echo "yes" >&6; }
 				break
 			fi
 		done
-		if test -z "$SDKPATH"
-		then
-			{ $as_echo "$as_me:${as_lineno-$LINENO}: result: no" >&5
-$as_echo "no" >&6; }
-			as_fn_error $? "We couldn't find the SDK for OS X $deploy_target" "$LINENO" 5
-		fi
 		{ $as_echo "$as_me:${as_lineno-$LINENO}: result: yes" >&5
 $as_echo "yes" >&6; }
 		;;
 	esac

 	#
-	# Add a -mmacosx-version-min flag to force tests that
-	# use the compiler, as well as the build itself, not to,
-	# for example, use compiler or linker features not supported
-	# by the minimum targeted version of the OS.
-	#
-	# Add an -isysroot flag to use the SDK.
-	#
-	CFLAGS="-mmacosx-version-min=$deploy_target -isysroot $SDKPATH $CFLAGS"
-	CXXFLAGS="-mmacosx-version-min=$deploy_target -isysroot $SDKPATH $CXXFLAGS"
-	LDFLAGS="-mmacosx-version-min=$deploy_target -isysroot $SDKPATH $LDFLAGS"
-
-	#
-	# Add a -sdkroot flag to use with osx-app.sh.
-	#
-	OSX_APP_FLAGS="-sdkroot $SDKPATH"
-
-	#
-	# XXX - do we need this to build the Wireshark wrapper?
-	# XXX - is this still necessary with the -mmacosx-version-min
-	# flag being set?
-	#
-	OSX_DEPLOY_TARGET="MACOSX_DEPLOYMENT_TARGET=$deploy_target"
-
-	#
 	# In the installer package XML file, give the deployment target
 	# as the minimum version.
 	#

