require 'formula'

def build_clang?; ARGV.include? '--with-clang'; end
def build_universal?; ARGV.build_universal?; end
def build_shared?; ARGV.include? '--shared'; end
def build_rtti?; ARGV.include? '--rtti'; end

class Clang < Formula
  homepage  'http://llvm.org/'
  url       'http://llvm.org/releases/2.9/clang-2.9.tgz'
  md5       '634de18d04b7a4ded19ec4c17d23cfca'
end

class Llvm < Formula
  homepage  'http://llvm.org/'
  url       'http://llvm.org/releases/2.9/llvm-2.9.tgz'
  md5       '793138412d2af2c7c7f54615f8943771'

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

    Dir.chdir clang_dir do
      system "make install"
      bin.install 'tools/scan-build/set-xcode-analyzer'
    end if build_clang?
  end

  def caveats; <<-EOS.undent
    If you already have LLVM installed, then "brew upgrade llvm" might not work.
    Instead, try:
        brew rm llvm & brew install llvm
    EOS
  end
end


__END__
diff --git i/Makefile.rules w/Makefile.rules
index 5fc77a5..a6baaf4 100644
--- i/Makefile.rules
+++ w/Makefile.rules
@@ -507,7 +507,7 @@ ifeq ($(HOST_OS),Darwin)
   # Get "4" out of 10.4 for later pieces in the makefile.
   DARWIN_MAJVERS := $(shell echo $(DARWIN_VERSION)| sed -E 's/10.([0-9]).*/\1/')

-  LoadableModuleOptions := -Wl,-flat_namespace -Wl,-undefined,suppress
+  LoadableModuleOptions := -Wl,-undefined,dynamic_lookup
   SharedLinkOptions := -dynamiclib
   ifneq ($(ARCH),ARM)
     SharedLinkOptions += -mmacosx-version-min=$(DARWIN_VERSION)
