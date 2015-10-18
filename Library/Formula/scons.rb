class Scons < Formula
  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "http://www.scons.org"
  url "https://downloads.sourceforge.net/project/scons/scons/2.4.0/scons-2.4.0.tar.gz"
  sha256 "1892f472934f1f5947d0e4c5d01e3b992641425553faab4062ddb8e3504c1fb2"

  bottle do
    cellar :any_skip_relocation
    sha256 "df12a7fe918c3e3f1a70ed8595e9b6195ebd3bd48b3d97a63074af615121a2ff" => :el_capitan
    sha256 "83130aad47e914d0c59ba71a005e391e4d171f1e39e4d3d65e54c82e64aa2430" => :yosemite
    sha256 "94be41a6f69b02eab60d80336c1a344b923f60d3bf7fad75290749b58609ca17" => :mavericks
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
