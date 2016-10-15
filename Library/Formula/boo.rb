require "formula"

class Boo < Formula
  homepage "http://boo.codehaus.org/"
  url "http://dist.codehaus.org/boo/distributions/boo-0.9.4.9-src.tar.bz2"
  sha1 "062b213d4aafbefb6d1e2e56707182d76f9089dd"

  depends_on "pkg-config" => :build
  depends_on "nant" => :build
  depends_on "mono"

  def install
    # fix mime path detection, don't require gtksourceview to build and help nant with a missing directory
    # see https://trac.macports.org/browser/trunk/dports/lang/boo/files/patch-default.build.diff
    inreplace "default.build", "${pkg-config::get-variable('shared-mime-info','prefix')}", "${install.prefix}"
    inreplace "default.build", "${pkg-config::get-variable('gtksourceview-1.0','prefix')}", "/tmp"
    mkdir_p buildpath/"build/pt"
    system "nant", "-nologo"
    system "nant", "-nologo", "install", "-D:install.prefix=#{prefix}"
    # paths shouldn't begin with /usr/local to be usable without linking the formula
    Dir[bin/"*"].each do |f|
      inreplace f, "/usr/local", prefix
    end
  end

  test do
    test_str = "Hello Homebrew"
    # boo needs mono to be in the PATH
    ENV.prepend_path 'PATH', Formula["mono"].bin
    # make sure to find the boo assemblies even if the user has not set
    # MONO_GAC_PREFIX to HOMEBREW_PREFIX
    ENV["MONO_GAC_PREFIX"] = prefix

    output = `echo 'print "#{test_str}"' | #{bin}/booi -`
    assert $?.success?
    assert_equal test_str, output.strip

    hello = (testpath/"hello.boo")
    hello.write "print \"#{test_str}\"\n"
    `#{bin}/booc #{hello}`
    assert $?.success?
    output = `#{Formula["mono"].bin}/mono hello.exe`
    assert $?.success?
    assert_equal test_str, output.strip
  end
end
