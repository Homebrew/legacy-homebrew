require 'formula'

def build_clang?; ARGV.include? '--with-clang'; end
def build_all_targets?; ARGV.include? '--all-targets'; end
def build_analyzer?; ARGV.include? '--analyzer'; end
def build_universal?; ARGV.build_universal?; end
def build_shared?; ARGV.include? '--shared'; end
def build_rtti?; ARGV.include? '--rtti'; end
def build_jit?; ARGV.include? '--jit'; end

class Clang < Formula
  homepage  'http://llvm.org/'
  url       'http://llvm.org/releases/3.0/clang-3.0.tar.gz'
  md5       '43350706ae6cf05d0068885792ea0591'

  head      'http://llvm.org/git/clang.git'
end

class Llvm < Formula
  homepage  'http://llvm.org/'
  url       'http://llvm.org/releases/3.0/llvm-3.0.tar.gz'
  md5       'a8e5f5f1c1adebae7b4a654c376a6005'

  head      'http://llvm.org/git/llvm.git'

  bottle do
    sha1 'f6feaab7d1e4f45cd5f0b63d465e65f491fcc27c' => :lion
    sha1 '0b4a9baac5cd07192f992ef3621371e9cde3979a' => :snowleopard
  end

  def patches
    # changes the link options for the shared library build
    # to use the preferred way to build libraries in Mac OS X
    # Reported upstream: http://llvm.org/bugs/show_bug.cgi?id=8985
    DATA if build_shared?
  end

  def options
    [['--with-clang', 'Build clang'],
     ['--analyzer', 'Build clang analyzer'],
     ['--shared', 'Build shared library'],
     ['--all-targets', 'Build all target backends'],
     ['--rtti', 'Build with RTTI information'],
     ['--universal', 'Build both i386 and x86_64 architectures'],
     ['--jit', 'Build with Just In Time (JIT) compiler functionality']]
  end

  def install
    if build_shared? && build_universal?
      onoe "Cannot specify both shared and universal (will not build)"
      exit 1
    end

    Clang.new("clang").brew { clang_dir.install Dir['*'] } if build_clang? or build_analyzer?

    if build_universal?
      ENV['UNIVERSAL'] = '1'
      ENV['UNIVERSAL_ARCH'] = 'i386 x86_64'
    end

    ENV['REQUIRES_RTTI'] = '1' if build_rtti?

    configure_options = [
      "--prefix=#{prefix}",
      "--enable-optimized",
      # As of LLVM 3.0, the only bindings offered are for OCaml and attempting
      # to build these when Homebrew's OCaml is installed results in errors.
      #
      # See issue #8947 for details.
      "--enable-bindings=none"
    ]

    if build_all_targets?
      configure_options << "--enable-targets=all"
    else
      configure_options << "--enable-targets=host-only"
    end

    configure_options << "--enable-shared" if build_shared?
    configure_options << "--enable-jit" if build_jit?

    system "./configure", *configure_options

    system "make" # separate steps required, otherwise the build fails
    system "make install"

    cd clang_dir do
      system "make install"
      bin.install 'tools/scan-build/set-xcode-analyzer'
    end if build_clang? or build_analyzer?

    cd clang_dir do
      bin.install 'tools/scan-build/scan-build'
      bin.install 'tools/scan-build/ccc-analyzer'
      bin.install 'tools/scan-build/c++-analyzer'
      bin.install 'tools/scan-build/sorttable.js'
      bin.install 'tools/scan-build/scanview.css'

      bin.install 'tools/scan-view/scan-view'
      bin.install 'tools/scan-view/ScanView.py'
      bin.install 'tools/scan-view/Reporter.py'
      bin.install 'tools/scan-view/startfile.py'
      bin.install 'tools/scan-view/Resources'
    end if build_analyzer?
  end

  def test
    system "#{bin}/llvm-config", "--version"
  end

  def caveats; <<-EOS.undent
    If you already have LLVM installed, then "brew upgrade llvm" might not work.
    Instead, try:
        brew rm llvm && brew install llvm
    EOS
  end

  def clang_dir
    buildpath/'tools/clang'
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
