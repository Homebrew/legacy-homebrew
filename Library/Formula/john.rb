require 'formula'

class John < Formula
  homepage 'http://www.openwall.com/john/'
  url 'http://www.openwall.com/john/j/john-1.8.0.tar.gz'
  sha1 '52d3e0afe885c0077839c8df30a9543505d883d8'

  option 'jumbo', 'Build with jumbo features'

  head 'cvs://:pserver:anoncvs:anoncvs@anoncvs.owl.openwall.com:/cvs:Owl/packages/john/john' unless build.include?('jumbo')

  if build.include? 'jumbo'
    url 'http://www.openwall.com/john/g/john-1.7.9.tar.bz2'
    sha1 '8f77bdd42b7cf94ec176f55ea69c4da9b2b8fe3b'
    head 'https://github.com/magnumripper/JohnTheRipper.git', :branch => 'bleeding-jumbo'
  end

  def patches
    p = [DATA] # Taken from MacPorts, tells john where to find runtime files
    p << "http://www.openwall.com/john/g/john-1.7.9-jumbo-7.diff.gz" if build.include? 'jumbo' and !build.head?
    return p
  end

  fails_with :llvm do
    build 2334
    cause "Don't remember, but adding this to whitelist 2336."
  end

  fails_with :clang do
    build 425
    cause "rawSHA1_ng_fmt.c:535:19: error: redefinition of '_mm_testz_si128'"
  end if build.include? 'jumbo'

  fails_with :clang do
    cause "rawSHA1_ng_fmt.c:541:19: error: redefinition of '_mm_testz_si128'"
  end if build.include? 'jumbo' and build.head?

  def cuda?
    File.directory? '/usr/local/cuda' or File.symlink? '/usr/local/cuda'
  end

  def install
    ENV.deparallelize
    arch = Hardware.is_64_bit? ? '64' : 'sse2'
    arch += case
      when build.include?('jumbo')
        if build.head? and cuda?
          '-gpu'
        else
          '-opencl'
        end
      else
        ''
    end

    cd 'src' do
      inreplace 'Makefile' do |s|
        s.change_make_var! "CC", ENV.cc
        if build.include?('jumbo') && MacOS.version != :leopard && ENV.compiler != :clang
          s.change_make_var! "OMPFLAGS", "-fopenmp -msse2 -D_FORTIFY_SOURCE=0"
        end
        if build.include?('jumbo') and build.head? and cuda?
          s.change_make_var! "NVCC", "/usr/local/cuda/bin/nvcc"
          s.change_make_var! "LD", ENV.cxx
          s.change_make_var! "CCBIN_OSX", ""
        end
      end
      system "make", "clean", "macosx-x86-#{arch}"
    end

    # Remove the README symlink and install the real file
    rm 'README' if File.exist?('README')
    prefix.install 'doc/README'
    doc.install Dir['doc/*']

    # Only symlink the binary into bin
    (share/'john').install Dir['run/*']
    bin.install_symlink share/'john/john'

    # Source code defaults to 'john.ini', so rename
    mv share/'john/john.conf', share/'john/john.ini'
  end
end


__END__
--- a/src/params.h	2012-08-30 13:24:18.000000000 -0500
+++ b/src/params.h	2012-08-30 13:25:13.000000000 -0500
@@ -70,15 +70,15 @@
  * notes above.
  */
 #ifndef JOHN_SYSTEMWIDE
-#define JOHN_SYSTEMWIDE			0
+#define JOHN_SYSTEMWIDE			1
 #endif
 
 #if JOHN_SYSTEMWIDE
 #ifndef JOHN_SYSTEMWIDE_EXEC /* please refer to the notes above */
-#define JOHN_SYSTEMWIDE_EXEC		"/usr/libexec/john"
+#define JOHN_SYSTEMWIDE_EXEC		"HOMEBREW_PREFIX/share/john"
 #endif
 #ifndef JOHN_SYSTEMWIDE_HOME
-#define JOHN_SYSTEMWIDE_HOME		"/usr/share/john"
+#define JOHN_SYSTEMWIDE_HOME		"HOMEBREW_PREFIX/share/john"
 #endif
 #define JOHN_PRIVATE_HOME		"~/.john"
 #endif
