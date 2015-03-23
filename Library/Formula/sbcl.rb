class Sbcl < Formula
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/1.2.9/sbcl-1.2.9-source.tar.bz2"
  sha1 "788e38d4c64fa1f99a5297dce72e87f3958e98a1"

  head "git://sbcl.git.sourceforge.net/gitroot/sbcl/sbcl.git"

  bottle do
    sha256 "4b455f19a7c9508dab431f3f317a94afe96b4e8f5dda8ec33caad5112f904319" => :yosemite
    sha256 "472e3b47c30712e7d1b09b92eaae561cde95c9a754eeed53a10c9a0f67cedcc8" => :mavericks
    sha256 "7440077b7b6bec6de8775a0dc1fc5ce4d173d255094dc208304441d2cdb669be" => :mountain_lion
  end

  fails_with :llvm do
    build 2334
    cause "Compilation fails with LLVM."
  end

  option "32-bit"
  option "without-threads", "Build SBCL without support for native threads"
  option "without-core-compression", "Build SBCL without support for compressed cores and without a dependency on zlib"
  option "with-ldb", "Include low-level debugger in the build"
  option "with-internal-xref", "Include XREF information for SBCL internals (increases core size by 5-6MB)"

  # Current binary versions are listed at http://sbcl.sourceforge.net/platform-table.html

  resource "bootstrap64" do
    url "https://downloads.sourceforge.net/project/sbcl/sbcl/1.1.8/sbcl-1.1.8-x86-64-darwin-binary.tar.bz2"
    sha1 "cffd8c568588f48bd0c69295a385b662d27983cf"
  end

  resource "bootstrap32" do
    url "https://downloads.sourceforge.net/project/sbcl/sbcl/1.1.6/sbcl-1.1.6-x86-darwin-binary.tar.bz2"
    sha1 "35a76b93f8714bc34ba127df4aaf69aacfc08164"
  end

  patch :p0 do
    url "https://trac.macports.org/export/88830/trunk/dports/lang/sbcl/files/patch-base-target-features.diff"
    sha1 "49cf79e8d687e0a90db0fdc022a5f73181629d6e"
  end

  patch :p0 do
    url "https://trac.macports.org/export/88830/trunk/dports/lang/sbcl/files/patch-make-doc.diff"
    sha1 "65d0beec43707ff5bf3262b8f12ca4514e58ce15"
  end

  patch :p0 do
    url "https://trac.macports.org/export/88830/trunk/dports/lang/sbcl/files/patch-posix-tests.diff"
    sha1 "cde8db247d153c6272cc96a6716721fd623010cb"
  end

  patch :p0 do
    url "https://trac.macports.org/export/88830/trunk/dports/lang/sbcl/files/patch-use-mach-exception-handler.diff"
    sha1 "4d08e56e7e261db47ffdfef044149b001e6cd7c1"
  end

  # Restore parallel build support.
  # See: https://bugs.launchpad.net/sbcl/+bug/1434768
  patch :DATA

  def write_features
    features = []
    features << ":sb-thread" if build.with? "threads"
    features << ":sb-core-compression" if build.with? "core-compression"
    features << ":sb-ldb" if build.with? "ldb"
    features << ":sb-xref-for-internals" if build.with? "internal-xref"

    File.open("customize-target-features.lisp", "w") do |file|
      file.puts "(lambda (list)"
      features.each do |f|
        file.puts "  (pushnew #{f} list)"
      end
      file.puts "  list)"
    end
  end

  def install
    write_features

    # Remove non-ASCII values from environment as they cause build failures
    # More information: http://bugs.gentoo.org/show_bug.cgi?id=174702
    ENV.delete_if do |_, value|
      value =~ /[\x80-\xff]/n
    end

    bootstrap = (build.build_32_bit? || !MacOS.prefer_64_bit?) ? "bootstrap32" : "bootstrap64"
    resource(bootstrap).stage do
      # We only need the binaries for bootstrapping, so don't install anything:
      command = "#{Dir.pwd}/src/runtime/sbcl"
      core = "#{Dir.pwd}/output/sbcl.core"
      xc_cmdline = "#{command} --core #{core} --disable-debugger --no-userinit --no-sysinit"

      cd buildpath do
        ENV["SBCL_ARCH"] = "x86" if build.build_32_bit?
        Pathname.new("version.lisp-expr").write('"1.0.99.999"') if build.head?
        system "./make.sh", "--prefix=#{prefix}", "--xc-host=#{xc_cmdline}"
      end
    end

    ENV["INSTALL_ROOT"] = prefix
    system "sh", "install.sh"
  end

  test do
    (testpath/"simple.sbcl").write <<-EOS.undent
      (write-line (write-to-string (+ 2 2)))
    EOS
    output = shell_output("#{bin}/sbcl --script #{testpath}/simple.sbcl")
    assert_equal "4", output.strip
  end
end
__END__
--- a/contrib/asdf/Makefile
+++ b/contrib/asdf/Makefile
@@ -8,7 +8,7 @@ $(UIOP_FASL):: uiop.lisp ../../output/sbcl.core
	mkdir -p $(DEST)
	$(SBCL) --eval '(compile-file #p"SYS:CONTRIB;ASDF;UIOP.LISP" :output-file (parse-native-namestring "$@"))' </dev/null

-$(ASDF_FASL):: asdf.lisp ../../output/sbcl.core
+$(ASDF_FASL):: asdf.lisp ../../output/sbcl.core $(UIOP_FASL)
	if [ -d asdf-upstream ] ; then rm -rf asdf-upstream ; fi
	mkdir -p $(DEST)
	$(SBCL) --eval '(compile-file #p"SYS:CONTRIB;ASDF;ASDF.LISP" :output-file (parse-native-namestring "$@"))' </dev/null
