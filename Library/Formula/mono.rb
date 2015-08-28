class Mono < Formula
  desc "Cross platform, open source .NET development framework"
  homepage "http://www.mono-project.com/"
  url "http://download.mono-project.com/sources/mono/mono-4.2.0.179.tar.bz2"
  sha256 "fc53c825b8f1e83eaa52a681410261a5b0ac47d36ffd2b58581c476c2690933f"

  # xbuild requires the .exe files inside the runtime directories to
  # be executable
  skip_clean "lib/mono"

  bottle do
    sha256 "0c18edef9deeb162ff119527a3113ee1d98b308f70d266f6f5d66619ecd12d12" => :yosemite
    sha256 "8b70a9ae0465cbb4648ef3d7042ed8d7aab7d2eca25ae1b8f686696b37ac28aa" => :mavericks
    sha256 "d3d9b118a27e3af2455925e83de0c44d4464660886c07fe5d21695f21471377a" => :mountain_lion
  end

  resource "monolite" do
    url "http://storage.bos.xamarin.com/mono-dist-4.2.0-release/9b/9b990f2b19b1a534925cce3ddaabb70654b76066/monolite-135-latest.tar.gz"
    sha256 "1529edbf34ebe498d315464e1211e65531ba25c492ba678a5bb079986a784131"
  end

  def install
    # a working mono is required for the the build - monolite is enough
    # for the job
    (buildpath+"mcs/class/lib/monolite").install resource("monolite")

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
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
    (testpath/test_name).write <<-EOS.undent
      public class Hello1
      {
         public static void Main()
         {
            System.Console.WriteLine("#{test_str}");
         }
      }
    EOS
    shell_output "#{bin}/mcs #{test_name}"
    output = shell_output "#{bin}/mono hello.exe"
    assert_match test_str, output.strip

    # Tests that xbuild is able to execute lib/mono/*/mcs.exe
    (testpath/"test.csproj").write <<-EOS.undent
      <?xml version="1.0" encoding="utf-8"?>
      <Project ToolsVersion="4.0" DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
        <PropertyGroup>
          <AssemblyName>HomebrewMonoTest</AssemblyName>
          <TargetFrameworkVersion>v4.5</TargetFrameworkVersion>
        </PropertyGroup>
        <ItemGroup>
          <Compile Include="#{test_name}" />
        </ItemGroup>
        <Import Project="$(MSBuildBinPath)\\Microsoft.CSharp.targets" />
      </Project>
    EOS
    shell_output "#{bin}/xbuild test.csproj"
  end

  def caveats; <<-EOS.undent
    To use the assemblies from other formulae you need to set:
      export MONO_GAC_PREFIX="#{HOMEBREW_PREFIX}"
    EOS
  end
end
