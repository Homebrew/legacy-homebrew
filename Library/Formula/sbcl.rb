class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/1.2.12/sbcl-1.2.12-source.tar.bz2"
  sha256 "b65bc878f15b8dc87582498780714e06c32a161aaa579e6f0216fd372247c9ad"

  head "git://sbcl.git.sourceforge.net/gitroot/sbcl/sbcl.git"

  bottle do
    sha256 "88af924875adfb1d6526a4642a516fb9e02f22e0ff01f73306e60516fe1cf12a" => :yosemite
    sha256 "b6275cda423c3ff0e2b38ad864eb9ec5ea7ece88dfb3e69ef0b42c8a35f6d415" => :mavericks
    sha256 "e05b809845cd4f80a8b821d80c11f568cbd8f3ae15b44ab1bcdb2d55a738486f" => :mountain_lion
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
