class Scons < Formula
  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "http://www.scons.org"
  url "https://downloads.sourceforge.net/project/scons/scons/2.3.6/scons-2.3.6.tar.gz"
  sha256 "98adaa351d8f4e4068a5bf1894bdd7f85b390c8c3f80d437cf8bb266012404df"

  bottle do
    cellar :any
    sha256 "1f99ce6c3eeb9df4b503c470c982e00f394be3f813729e800ad4ca249b4c4e6d" => :yosemite
    sha256 "b2e5ffe24de2dd6d62da181c03b968d4f9c3eae41096e6d4bd0a2c480fb1ada1" => :mavericks
    sha256 "308d20365203d26f64c56187c3e4d7b8bec3a4c160dd1005d96544b07a03cdbd" => :mountain_lion
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
