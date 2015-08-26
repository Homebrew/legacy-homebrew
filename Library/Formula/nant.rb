class Nant < Formula
  desc ".NET build tool"
  homepage "http://nant.sourceforge.net/"
  url "https://downloads.sourceforge.net/nant/nant/nant-0.92-src.tar.gz"
  sha256 "72d4d585267ed7f03e1aa75087d96f4f8d49ee976c32d974c5ab1fef4d4f8305"

  bottle do
    cellar :any
    sha256 "2d0fc84252d49d67c17708f6250232df8db7e7e6bf6ca42a47769813cc1e33c5" => :yosemite
    sha256 "dd78ffaca700b47ad47a432e858e24de155402241d29b4276cf3306d5e258557" => :mavericks
    sha256 "383d20c8156b3687bdc9a9e9d7cb55dddea69569fbb1a74ef79552bcb3a539f5" => :mountain_lion
  end

  depends_on "pkg-config" => :run
  depends_on "mono"

  patch do
    # fix build with newer versions of mono
    url "https://github.com/nant/nant/commit/69c8ee96493c5d953212397c8ca06c2392372ca4.diff"
    sha256 "1194a3b5c8e65d47e606f9d0f3b348fb6fe1998db929a7f711a9e172764b8075"
  end

  def install
    ENV.deparallelize

    # https://github.com/nant/nant/issues/151#issuecomment-125685734
    system "make", "install", "MCS=mcs", "prefix=#{prefix}"
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
