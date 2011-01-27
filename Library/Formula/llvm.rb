require 'formula'

def build_clang?; ARGV.include? '--with-clang'; end
def build_universal?; ARGV.include? '--universal'; end
def build_shared?; ARGV.include? '--shared'; end
def build_rtti?; ARGV.include? '--rtti'; end

class Clang <Formula
  url       'http://llvm.org/releases/2.8/clang-2.8.tgz'
  homepage  'http://llvm.org/'
  md5       '10e14c901fc3728eecbd5b829e011b59'
end

class Llvm <Formula
  url       'http://llvm.org/releases/2.8/llvm-2.8.tgz'
  homepage  'http://llvm.org/'
  md5       '220d361b4d17051ff4bb21c64abe05ba'

  def patches
    # changes the link options for the shared library build
    # to use the preferred way to build libraries in Mac OS X
    # Reported upstream: http://llvm.org/bugs/show_bug.cgi?id=8985
    DATA if build_shared?
  end

  def options
    [['--with-clang', 'Also build & install clang'],
     ['--shared', 'Build shared library'],
     ['--rtti', 'Build with RTTI information'],
     ['--universal', 'Build both i386 and x86_64 architectures']]
  end

  def install
    ENV.gcc_4_2 # llvm can't compile itself

    if build_shared? && build_universal?
      onoe "Cannot specify both shared and universal (will not build)"
      exit 1
    end

    if build_clang?
      clang_dir = Pathname.new(Dir.pwd)+'tools/clang'
      Clang.new.brew { clang_dir.install Dir['*'] }
    end

    if build_universal?
      ENV['UNIVERSAL'] = '1'
      ENV['UNIVERSAL_ARCH'] = 'i386 x86_64'
    end

    ENV['REQUIRES_RTTI'] = '1' if build_rtti?

    configure_options = ["--prefix=#{prefix}",
                         "--enable-targets=host-only",
                         "--enable-optimized"]

    configure_options << "--enable-shared" if build_shared?

    system "./configure", *configure_options

    system "make" # separate steps required, otherwise the build fails
    system "make install"

    if build_clang?
      Dir.chdir clang_dir do
        system "make install"
      end
    end
  end

  def caveats; <<-EOS
    If you already have LLVM installed, then "brew upgrade llvm" might not
    work. Instead, try:
        $ brew rm llvm
        $ brew install llvm
    EOS
  end
end

__END__
diff --git a/Makefile.rules b/Makefile.rules
index 9cff105..44d5b2d 100644
--- a/Makefile.rules
+++ b/Makefile.rules
@@ -497,7 +497,7 @@ ifeq ($(HOST_OS),Darwin)
   # Get "4" out of 10.4 for later pieces in the makefile.
   DARWIN_MAJVERS := $(shell echo $(DARWIN_VERSION)| sed -E 's/10.([0-9]).*/\1/')

-  SharedLinkOptions=-Wl,-flat_namespace -Wl,-undefined,suppress \
+  SharedLinkOptions=-Wl,-undefined,dynamic_lookup \
                     -dynamiclib
   ifneq ($(ARCH),ARM)
     SharedLinkOptions += -mmacosx-version-min=$(DARWIN_VERSION)
