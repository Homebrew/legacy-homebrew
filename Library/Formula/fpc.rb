class Fpc < Formula
  desc "Free Pascal: multi-architecture Pascal compiler"
  homepage "http://www.freepascal.org/"
  url "https://downloads.sourceforge.net/project/freepascal/Source/3.0.0/fpc-3.0.0.source.tar.gz"
  sha256 "46354862cefab8011bcfe3bc2942c435f96a8958b245c42e10283ec3e44be2dd"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "c059c97043807fe5cb02ad09d4000782e131db3081788753735375079f5a9acd" => :el_capitan
    sha256 "846c012b1e92595844e9410c36476288f013fddb74e6c565795e6ab61a382a85" => :yosemite
    sha256 "5c2c1c39cec7ec2fec2885520c5ff485054323cd95199bb394ff791a9bad5531" => :mavericks
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

    # Prevent non-executable audit warning
    rm_f Dir[bin/"*.rsj"]

    # Generate a default fpc.cfg to set up unit search paths
    system "#{bin}/fpcmkcfg", "-p", "-d", "basepath=#{lib}/fpc/#{version}", "-o", "#{prefix}/etc/fpc.cfg"
  end

  test do
    hello = <<-EOS.undent
      program Hello;
      uses GL;
      begin
        writeln('Hello Homebrew')
      end.
    EOS
    (testpath/"hello.pas").write(hello)
    system "#{bin}/fpc", "hello.pas"
    assert_equal "Hello Homebrew", `./hello`.strip
  end
end
