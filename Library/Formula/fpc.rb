class Fpc < Formula
  desc "Free Pascal: multi-architecture Pascal compiler"
  homepage "http://www.freepascal.org/"
  url "https://downloads.sourceforge.net/project/freepascal/Source/2.6.4/fpc-2.6.4.source.tar.gz"
  sha256 "c16f2e6e0274c7afc0f1d2dded22d0fec98fe329b1d5b2f011af1655f3a1cc29"

  bottle do
    cellar :any
    sha1 "c77e7a5b6b9fb84b9d90bb4515a8557ccb98a253" => :mavericks
    sha1 "47f760e84fc84f845718efe4737402e086de705c" => :mountain_lion
    sha1 "90d3b9d4ad5e3d06efc0108e0b1dbd8e58b18034" => :lion
  end

  resource "bootstrap" do
    url "https://downloads.sourceforge.net/project/freepascal/Bootstrap/2.6.4/universal-macosx-10.5-ppcuniversal.tar.bz2"
    sha256 "e7243e83e6a04de147ebab7530754ec92cd1fbabbc9b6b00a3f90a796312f3e9"
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
