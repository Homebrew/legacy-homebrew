require "formula"

class Nant < Formula
  homepage "http://nant.sourceforge.net/"
  url "https://downloads.sourceforge.net/nant/nant/nant-0.92-src.tar.gz"
  sha1 "5f95dea73f82e26aaf4df46da460604e856479aa"

  depends_on "mono"
  depends_on "pkg-config" => :build

  patch do
    # fix build with newer versions of mono
    url "https://github.com/nant/nant/commit/69c8ee96493c5d953212397c8ca06c2392372ca4.diff"
    sha1 "47142439263f22f7fee1608f4b50cbff51496f9b"
  end

  def install
    ENV.deparallelize
    system "make", "install", "prefix=#{prefix}"
    inreplace bin/"nant", bin/"mono", "mono"
  end

  test do
    ENV.prepend_path "PATH", Formula["mono"].bin
    (testpath/"default.build").write <<-EOS.undent
      <project default="build"
        xmlns="http://nant.sf.net/release/0.86-beta1/nant.xsd">
        <target name="build">
          <csc target="exe" output="hello.exe">
            <sources>
              <include name="hello.cs" />
            </sources>
          </csc>
        </target>
      </project>
    EOS
    (testpath/"hello.cs").write <<-EOS.undent
      public class Hello1
      {
         public static void Main()
         {
            System.Console.WriteLine("hello homebrew!");
         }
      }
    EOS
    system bin/"nant"
  end
end
