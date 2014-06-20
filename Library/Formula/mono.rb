require "formula"

class Mono < Formula
  homepage "http://www.mono-project.com/"
  url "http://download.mono-project.com/sources/mono/mono-3.4.0.tar.bz2"
  sha1 "bae86f50f9a29d68d4e1917358996e7186e7f89e"

  bottle do
    sha1 "dca650732ccb8aac36e56cd7bce03851d69e2d1c" => :mavericks
    sha1 "498c0c5c8dd7c8b867072cb96aa9f013c51e4d78" => :mountain_lion
    sha1 "b0a97c07d45fab229594d1742baef9cc97cc8405" => :lion
  end

  resource "monolite" do
    url "http://storage.bos.xamarin.com/mono-dist-master/latest/monolite-111-latest.tar.gz"
    sha1 "af90068351895082f03fdaf2840b7539e23e3f32"
  end

  # This file is missing in the 3.4.0 tarball as of 2014-05-14...
  # See https://bugzilla.xamarin.com/show_bug.cgi?id=18690
  resource "Microsoft.Portable.Common.targets" do
    url "https://raw.githubusercontent.com/mono/mono/mono-3.4.0/mcs/tools/xbuild/targets/Microsoft.Portable.Common.targets"
    sha1 "7624c3f6d1e4867da2e217ba0d1595a224971e27"
  end

  # help mono find its MonoPosixHelper lib when it is not in a system path
  # see https://bugzilla.xamarin.com/show_bug.cgi?id=18555
  patch do
    url "https://bugzilla.xamarin.com/attachment.cgi?id=6399"
    sha1 "d011dc55f341feea0bdb8aa645688b815910b734"
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
