class Mono < Formula
  desc "Cross platform, open source .NET development framework"
  homepage "http://www.mono-project.com/"
  url "http://download.mono-project.com/sources/mono/mono-4.0.1.tar.bz2"
  sha256 "ff1f15f3b8d43c6a2818c00fabe377b2d8408ad14acd9d507658b4cae00f5bce"

  # xbuild requires the .exe files inside the runtime directories to
  # be executable
  skip_clean "lib/mono"

  bottle do
    sha256 "7a43ae0a117cbc6568f42e164e9b6381fa8be868211f03fff4269b72955d6d4e" => :yosemite
    sha256 "f17c96a484176dd3e3715c5c0a3421c7027b739585482543b8d483139ef1186c" => :mavericks
    sha256 "93690424e73a62c5641b9a9bed86117813f6d8172656726c7c33e377885db37d" => :mountain_lion
  end

  resource "monolite" do
    url "http://storage.bos.xamarin.com/mono-dist-4.0.0-release/79/7975f5090d8b0d266dc0ba824295d92edd8873da/monolite-117-latest.tar.gz"
    sha256 "7c48200e4c8bdfe890a0b5301975feac0b2fc6797e6accd00e7a366edbba92e7"
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
