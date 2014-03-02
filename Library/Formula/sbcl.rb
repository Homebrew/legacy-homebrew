require 'formula'

class Sbcl < Formula
  homepage 'http://www.sbcl.org/'
  url 'http://downloads.sourceforge.net/project/sbcl/sbcl/1.1.16/sbcl-1.1.16-source.tar.bz2'
  sha1 '27bad72be3eb4a078c362d1ec2a52cf9ec1d5ecb'

  head 'git://sbcl.git.sourceforge.net/gitroot/sbcl/sbcl.git'

  bottle do
    sha1 "86a3582cfbb2789c438c6a174869861842df32be" => :mavericks
    sha1 "95cd6954553cc4f98c62d18475c83e6ff7bb02b0" => :mountain_lion
    sha1 "07f044546e8a15e802b82907bbb1c4805bf99a28" => :lion
  end

  fails_with :llvm do
    build 2334
    cause "Compilation fails with LLVM."
  end

  option "32-bit"
  option "without-threads", "Build SBCL without support for native threads"
  option "with-ldb", "Include low-level debugger in the build"
  option "with-internal-xref", "Include XREF information for SBCL internals (increases core size by 5-6MB)"

  # Current binary versions are listed at http://sbcl.sourceforge.net/platform-table.html

  resource 'bootstrap64' do
    url 'http://downloads.sourceforge.net/project/sbcl/sbcl/1.1.8/sbcl-1.1.8-x86-64-darwin-binary.tar.bz2'
    sha1 'cffd8c568588f48bd0c69295a385b662d27983cf'
  end

  resource 'bootstrap32' do
    url 'http://downloads.sourceforge.net/project/sbcl/sbcl/1.1.6/sbcl-1.1.6-x86-darwin-binary.tar.bz2'
    sha1 '35a76b93f8714bc34ba127df4aaf69aacfc08164'
  end

  def patches
    { :p0 => [
        "https://trac.macports.org/export/88830/trunk/dports/lang/sbcl/files/patch-base-target-features.diff",
        "https://trac.macports.org/export/88830/trunk/dports/lang/sbcl/files/patch-make-doc.diff",
        "https://trac.macports.org/export/88830/trunk/dports/lang/sbcl/files/patch-posix-tests.diff",
        "https://trac.macports.org/export/88830/trunk/dports/lang/sbcl/files/patch-use-mach-exception-handler.diff"
    ]}
  end

  def write_features
    features = []
    features << ":sb-thread" unless build.include? "without-threads"
    features << ":sb-ldb" if build.include? "with-ldb"
    features << ":sb-xref-for-internals" if build.include? "with-internal-xref"

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
    ENV.delete_if do |key, value|
      value =~ /[\x80-\xff]/n
    end

    bootstrap = (build.build_32_bit? || !MacOS.prefer_64_bit?) ? 'bootstrap32' : 'bootstrap64'
    resource(bootstrap).stage do
      # We only need the binaries for bootstrapping, so don't install anything:
      command = Dir.pwd + "/src/runtime/sbcl"
      core = Dir.pwd + "/output/sbcl.core"
      xc_cmdline = "#{command} --core #{core} --disable-debugger --no-userinit --no-sysinit"

      cd buildpath do
        ENV['SBCL_ARCH'] = 'x86' if build.build_32_bit?
        Pathname.new("version.lisp-expr").write('"1.0.99.999"') if build.head?
        system "./make.sh", "--prefix=#{prefix}", "--xc-host=#{xc_cmdline}"
      end
    end

    ENV['INSTALL_ROOT'] = prefix
    system "sh install.sh"
  end

  test do
    (testpath/'simple.sbcl').write <<-EOS.undent
      (write-line (write-to-string (+ 2 2)))
    EOS
    output = `'#{bin}/sbcl' --script #{testpath}/simple.sbcl`
    assert_equal '4', output.strip
    assert_equal 0, $?.exitstatus
  end
end
