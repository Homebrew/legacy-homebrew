class Fpc < Formula
  desc "Free Pascal: multi-architecture Pascal compiler"
  homepage "http://www.freepascal.org/"
  url "https://downloads.sourceforge.net/project/freepascal/Source/2.6.4/fpc-2.6.4.source.tar.gz"
  sha256 "c16f2e6e0274c7afc0f1d2dded22d0fec98fe329b1d5b2f011af1655f3a1cc29"

  bottle do
    cellar :any
    sha256 "45462778a4998a7fa052bedb5989588fff6c8e492216bf254b7c4cd5d10fdabb" => :mavericks
    sha256 "617a926b5b13a63cd0af749ef0f44adec7a93c9f718ad63dca630d7e92291189" => :mountain_lion
    sha256 "bb3d3a5b9acaaf95b57a73b010be3d16749dfd42671a40c5c09c16bb24915fff" => :lion
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
