require "formula"

class Fpc < Formula
  homepage "http://www.freepascal.org/"
  url "https://downloads.sourceforge.net/project/freepascal/Source/2.6.4/fpc-2.6.4.source.tar.gz"
  sha1 "60eeadf65db25b10b174627457a5799bf0fd0d52"

  bottle do
    cellar :any
    sha1 "c77e7a5b6b9fb84b9d90bb4515a8557ccb98a253" => :mavericks
    sha1 "47f760e84fc84f845718efe4737402e086de705c" => :mountain_lion
    sha1 "90d3b9d4ad5e3d06efc0108e0b1dbd8e58b18034" => :lion
  end

  resource "bootstrap" do
    url "https://downloads.sourceforge.net/project/freepascal/Bootstrap/2.6.4/universal-macosx-10.5-ppcuniversal.tar.bz2"
    sha1 "1476a19ad7f901868fcbe3dc49e6d46a5865f722"
  end

  def install
    fpc_bootstrap = buildpath/"bootstrap"
    resource("bootstrap").stage { fpc_bootstrap.install Dir["*"] }

    fpc_compiler = fpc_bootstrap/"ppcuniversal"
    system "make", "build", "PP=#{fpc_compiler}"
    system "make", "install", "PP=#{fpc_compiler}", "PREFIX=#{prefix}"

    bin.install_symlink lib/"#{name}/#{version}/ppcx64"
  end

  test do
    hello = <<-EOS.undent
      program Hello;
      begin
        writeln('Hello Homebrew')
      end.
    EOS
    (testpath/"hello.pas").write(hello)
    system "#{bin}/fpc", "hello.pas"
    assert_equal "Hello Homebrew", `./hello`.strip
  end
end
