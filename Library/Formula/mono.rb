class Mono < Formula
  desc "Cross platform, open source .NET development framework"
  homepage "http://www.mono-project.com/"
  url "http://download.mono-project.com/sources/mono/mono-4.0.2.5.tar.bz2"
  sha256 "b074584eea5bbaaf29362486a69d70abe53d0d2feb334f231fa9c841cf6fd651"

  # xbuild requires the .exe files inside the runtime directories to
  # be executable
  skip_clean "lib/mono"

  bottle do
    sha256 "636be6e6ebc60017320ec3c205d952fd74ca784fe5d25ac90271fee7bf0ef922" => :yosemite
    sha256 "2fe5f35cbc70cc434fa20be89d7bd6c63705f06a5ed9f495396427bae3821da7" => :mavericks
    sha256 "80bddaefcd9c136bc763797cff98f3aa07ec758e348037fd24f07d2b1b795fbb" => :mountain_lion
  end

  # Fix compile and runtime error on OS X 10.11 Beta 3
  # https://github.com/mono/mono/pull/1919
  # https://bugzilla.xamarin.com/show_bug.cgi?id=31761
  patch do
    url "https://github.com/mono/mono/pull/1919.diff"
    sha256 "53c39c2145027fdf1a2233e12bd96da2c1164e1422e631cdb50598910b39a020"
  end

  resource "monolite" do
    url "http://storage.bos.xamarin.com/mono-dist-4.0.0-release/c1/c1b37f29b1a439acf7ef42a384550ab1dca5295a/monolite-117-latest.tar.gz"
    sha256 "a3bd1c826186e4896193ad1f909bf8756f66f62d1e249fe301b10bc80ebe0795"
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
