class Scons < Formula
  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "http://www.scons.org"
  url "https://downloads.sourceforge.net/project/scons/scons/2.4.1/scons-2.4.1.tar.gz"
  sha256 "8fc4f42928c69bcbb33e1be94b646f2c700b659693fabc778c192d4d22f753a7"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3660e9012706af7146bc9fbc6f49a24b2c4d3464bda7e616863fa1f74b474a5" => :el_capitan
    sha256 "ec8f843e6f368527556500a81af539884b8dc502a352742e9fcd94a36b4caf16" => :yosemite
    sha256 "af5e2c2014667d651be904091590cb8f9c65dc15651e84f531d523370f567ddb" => :mavericks
  end

  def install
    man1.install gzip("scons-time.1", "scons.1", "sconsign.1")
    system "/usr/bin/python", "setup.py", "install",
             "--prefix=#{prefix}",
             "--standalone-lib",
             # SCons gets handsy with sys.path---`scons-local` is one place it
             # will look when all is said and done.
             "--install-lib=#{libexec}/scons-local",
             "--install-scripts=#{bin}",
             "--install-data=#{libexec}",
             "--no-version-script", "--no-install-man"

    # Re-root scripts to libexec so they can import SCons and symlink back into
    # bin. Similar tactics are used in the duplicity formula.
    bin.children.each do |p|
      mv p, "#{libexec}/#{p.basename}.py"
      bin.install_symlink "#{libexec}/#{p.basename}.py" => p.basename
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      int main()
      {
        printf("Homebrew");
      }
    EOS
    (testpath/"SConstruct").write "Program('test.c')"
    system bin/"scons"
    assert_equal "Homebrew", shell_output("#{testpath}/test")
  end
end
