require "formula"

class Mono < Formula
  homepage "http://www.mono-project.com/"
  url "http://download.mono-project.com/sources/mono/mono-3.8.0.tar.bz2"
  sha1 "0e1fcaa0ec228830f9b0a650b6cfd3c098c82afc"

  # xbuild requires the .exe files inside the runtime directories to
  # be executable
  skip_clean "lib/mono"

  bottle do
    sha1 "2184aeba1346c3cbbed0dbf077466bbd826c3559" => :mavericks
    sha1 "982b56d443b6d0f65e0351f74afcf10175271fea" => :mountain_lion
    sha1 "df60a0666a1aa750e3e64d12d16a80ca1f7997da" => :lion
  end

  resource "monolite" do
    url "http://storage.bos.xamarin.com/mono-dist-master/latest/monolite-111-latest.tar.gz"
    sha1 "af90068351895082f03fdaf2840b7539e23e3f32"
  end

  def install
    # a working mono is required for the the build - monolite is enough
    # for the job
    (buildpath+"mcs/class/lib/monolite").install resource("monolite")

    args = %W[
      --prefix=#{prefix}
      --enable-nls=no
    ]
    args << "--build=" + (MacOS.prefer_64_bit? ? "x86_64": "i686") + "-apple-darwin"

    system "./configure", *args
    system "make"
    system "make", "install"
    # mono-gdb.py and mono-sgen-gdb.py are meant to be loaded by gdb, not to be
    # run directly, so we move them out of bin
    libexec.install bin/"mono-gdb.py", bin/"mono-sgen-gdb.py"
  end

  test do
    test_str = "Hello Homebrew"
    test_name = "hello.cs"
    hello = testpath/test_name
    hello.write <<-EOS.undent
      public class Hello1
      {
         public static void Main()
         {
            System.Console.WriteLine("#{test_str}");
         }
      }
    EOS
    `#{bin}/mcs #{hello}`
    assert $?.success?
    output = `#{bin}/mono hello.exe`
    assert $?.success?
    assert_equal test_str, output.strip

    # Tests that xbuild is able to execute lib/mono/*/mcs.exe
    xbuild = testpath/"test.csproj"
    xbuild.write <<-EOS.undent
      <?xml version="1.0" encoding="utf-8"?>
      <Project ToolsVersion="4.0" DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
        <PropertyGroup>
          <AssemblyName>HomebrewMonoTest</AssemblyName>
        </PropertyGroup>
        <ItemGroup>
          <Compile Include="#{test_name}" />
        </ItemGroup>
        <Import Project="$(MSBuildBinPath)\\Microsoft.CSharp.targets" />
      </Project>
    EOS
    system "#{bin}/xbuild", xbuild
    assert $?.success?
  end

  def caveats; <<-EOS.undent
    To use the assemblies from other formulae you need to set:
      export MONO_GAC_PREFIX="#{HOMEBREW_PREFIX}"
    EOS
  end
end
