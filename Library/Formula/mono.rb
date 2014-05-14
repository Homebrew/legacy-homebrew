require "formula"

class Mono < Formula
  homepage "http://www.mono-project.com/"
  url "http://download.mono-project.com/sources/mono/mono-3.4.0.tar.bz2"
  sha256 "fd4cadc6a849896c6a4382321f06ce9f224326affd2c8aaa47ba7218c0d951d4"

  resource "monolite" do
    url "http://storage.bos.xamarin.com/mono-dist-master/latest/monolite-111-latest.tar.gz"
    sha256 "d618a807444216a3ed5462d345df726f58b2c2a044c0c2f8faa9800efe03cc27"
  end

  # This file is missing in the 3.4.0 tarball as of 2014-05-14...
  # See https://bugzilla.xamarin.com/show_bug.cgi?id=18690
  resource "Microsoft.Portable.Common.targets" do
    url "https://raw.githubusercontent.com/mono/mono/master/mcs/tools/xbuild/targets/Microsoft.Portable.Common.targets"
    sha256 "dcdf6001cf01169df0f681f946d20d10cd6fa38a5a91f4f38ee4970b2923d09f"
  end

  # help mono find its MonoPosixHelper lib when it is not in a system path
  # see https://bugzilla.xamarin.com/show_bug.cgi?id=18555
  patch do
    url "https://bugzilla.xamarin.com/attachment.cgi?id=6399"
    sha256 "aea44d6cad3ac4fa1e64af2720d22badef1dc8e0accbc2e1329da270ba4e8dfa"
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

    # TODO: Remove once the updated 3.4.0 tarball gets built.
    (buildpath+"mcs/tools/xbuild/targets").install resource("Microsoft.Portable.Common.targets")

    system "make", "install"
    # mono-gdb.py and mono-sgen-gdb.py are meant to be loaded by gdb, not to be
    # run directly, so we move them out of bin
    libexec.install bin/"mono-gdb.py", bin/"mono-sgen-gdb.py"
  end

  test do
    test_str = "Hello Homebrew"
    hello = (testpath/"hello.cs")
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
  end

  def caveats; <<-EOS.undent
    To use the assemblies from other formulae you need to set:
      export MONO_GAC_PREFIX="#{HOMEBREW_PREFIX}"
    EOS
  end
end
