require 'formula'

# Reference: https://github.com/b4winckler/macvim/wiki/building
class Macvim < Formula
  homepage 'http://code.google.com/p/macvim/'
  url 'https://github.com/b4winckler/macvim/archive/snapshot-71.tar.gz'
  version '7.4-71'
  sha1 '09101e3e29ae517d6846159211ae64e1427b86c0'

  head 'https://github.com/b4winckler/macvim.git', :branch => 'master'

  option "custom-icons", "Try to generate custom document icons"
  option "override-system-vim", "Override system vim"

  depends_on :xcode
  depends_on 'cscope' => :recommended
  depends_on 'lua' => :optional
  depends_on 'luajit' => :optional
  depends_on :python => :recommended
  # Help us! :python3 in MacVim makes the window disappear, so only 2.x bindings!

  env :std if MacOS.version <= :snow_leopard
  # Help us! We'd like to use superenv in these environments too

  # Mavericks Patches:
  # * Fix Ruby.framework detection on OS X 10.9
  # * Allow building against specific Ruby.framework version matcing ruby-command
  # * Add missing version macros include for 10.9
  def patches
    DATA unless build.head?
  end

  def install
    # Set ARCHFLAGS so the Python app (with C extension) that is
    # used to create the custom icons will not try to compile in
    # PPC support (which isn't needed in Homebrew-supported systems.)
    ENV['ARCHFLAGS'] = "-arch #{MacOS.preferred_arch}"

    # If building for 10.7 or up, make sure that CC is set to "clang".
    ENV.clang if MacOS.version >= :lion

    # macvim HEAD only works with the current Ruby.framework because it builds with -framework Ruby
    system_ruby = build.head? ? "/System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin/ruby" : RUBY_PATH

    args = %W[
      --with-features=huge
      --enable-multibyte
      --with-macarchs=#{MacOS.preferred_arch}
      --enable-perlinterp
      --enable-rubyinterp
      --enable-tclinterp
      --with-ruby-command=#{system_ruby}
      --with-tlib=ncurses
      --with-compiledby=Homebrew
      --with-local-dir=#{HOMEBREW_PREFIX}
    ]

    args << "--with-macsdk=#{MacOS.version}" unless MacOS::CLT.installed?
    args << "--enable-cscope" if build.with? "cscope"

    if build.with? "lua"
      args << "--enable-luainterp"
      args << "--with-lua-prefix=#{HOMEBREW_PREFIX}"
    end

    if build.with? "luajit"
      args << "--enable-luainterp"
      args << "--with-lua-prefix=#{HOMEBREW_PREFIX}"
      args << "--with-luajit"
    end

    args << "--enable-pythoninterp=yes" if build.with? 'python'

    # MacVim seems to link Python by `-framework Python` (instead of
    # `python-config --ldflags`) and so we have to pass the -F to point to
    # where the Python.framework is located, we want it to use!
    # Also the -L is needed for the correct linking. This is a mess but we have
    # to wait until MacVim is really able to link against different Python's
    # on the Mac. Note configure detects brewed python correctly, but that
    # is ignored.
    # See https://github.com/mxcl/homebrew/issues/17908
    ENV.prepend 'LDFLAGS', "-L#{python2.libdir} -F#{python2.framework}" if python && python.brewed?

    unless MacOS::CLT.installed?
      # On Xcode-only systems:
      # Macvim cannot deal with "/Applications/Xcode.app/Contents/Developer" as
      # it is returned by `xcode-select -print-path` and already set by
      # Homebrew (in superenv). Instead Macvim needs the deeper dir to directly
      # append "SDKs/...".
      args << "--with-developer-dir=#{MacOS::Xcode.prefix}/Platforms/MacOSX.platform/Developer/"
    end

    system "./configure", *args

    if build.include? "custom-icons"
      # Get the custom font used by the icons
      cd 'src/MacVim/icons' do
        system "make getenvy"
      end
    else
      # Building custom icons fails for many users, so off by default.
      inreplace "src/MacVim/icons/Makefile", "$(MAKE) -C makeicns", ""
      inreplace "src/MacVim/icons/make_icons.py", "dont_create = False", "dont_create = True"
    end

    system "make"

    prefix.install "src/MacVim/build/Release/MacVim.app"
    inreplace "src/MacVim/mvim", /^# VIM_APP_DIR=\/Applications$/,
                                 "VIM_APP_DIR=#{prefix}"
    bin.install "src/MacVim/mvim"

    # Create MacVim vimdiff, view, ex equivalents
    executables = %w[mvimdiff mview mvimex gvim gvimdiff gview gvimex]
    executables += %w[vi vim vimdiff view vimex] if build.include? "override-system-vim"
    executables.each {|f| ln_s bin+'mvim', bin+f}
  end

  def caveats; <<-EOS.undent
    MacVim.app installed to:
      #{prefix}

    To link the application to a normal Mac OS X location:
        brew linkapps
    or:
        ln -s #{prefix}/MacVim.app /Applications
    EOS
  end
end

__END__
diff --git a/src/auto/configure b/src/auto/configure
index 4fd7b82..08af7f3 100755
--- a/src/auto/configure
+++ b/src/auto/configure
@@ -7206,8 +7208,9 @@ echo "${ECHO_T}$rubyhdrdir" >&6; }
	  librubyarg="$librubyarg"
	  RUBY_LIBS="$RUBY_LIBS -L$rubylibdir"
         elif test -d "/System/Library/Frameworks/Ruby.framework"; then
-                        RUBY_LIBS="-framework Ruby"
-                        RUBY_CFLAGS=
+            ruby_fw_ver=`$vi_cv_path_ruby -r rbconfig -e "print $ruby_rbconfig::CONFIG['ruby_version'][0,3]"`
+            RUBY_LIBS="/System/Library/Frameworks/Ruby.framework/Versions/$ruby_fw_ver/Ruby"
+            RUBY_CFLAGS="-I/System/Library/Frameworks/Ruby.framework/Versions/$ruby_fw_ver/Headers -DRUBY_VERSION=$rubyversion"
             librubyarg=
	fi

diff --git a/src/if_ruby.c b/src/if_ruby.c
index 4436e06..44fd5ee 100644
--- a/src/if_ruby.c
+++ b/src/if_ruby.c
@@ -96,11 +96,7 @@
 # define rb_num2int rb_num2int_stub
 #endif

-#ifdef FEAT_GUI_MACVIM
-# include <Ruby/ruby.h>
-#else
-# include <ruby.h>
-#endif
+#include <ruby.h>
 #ifdef RUBY19_OR_LATER
 # include <ruby/encoding.h>
 #endif
diff --git a/src/os_mac.h b/src/os_mac.h
index 78b79c2..54009ab 100644
--- a/src/os_mac.h
+++ b/src/os_mac.h
@@ -16,6 +16,9 @@
 # define OPAQUE_TOOLBOX_STRUCTS 0
 #endif

+/* Include MAC_OS_X_VERSION_* macros */
+#include <AvailabilityMacros.h>
+
 /*
  * Macintosh machine-dependent things.
  *
