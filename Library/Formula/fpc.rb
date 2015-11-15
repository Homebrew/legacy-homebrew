class Fpc < Formula
  desc "Free Pascal: multi-architecture Pascal compiler"
  homepage "http://www.freepascal.org/"
  url "https://downloads.sourceforge.net/project/freepascal/Source/3.0.0/fpc-3.0.0.source.tar.gz"
  sha256 "46354862cefab8011bcfe3bc2942c435f96a8958b245c42e10283ec3e44be2dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b52e73f38825e27f17fc75b4fd54f2c80242bc84d1637041991388ef336a7be" => :el_capitan
    sha256 "35fac52eb637dd5696b4d988813c9a6ed19105caee0b5726032eb4f33d5a0ef9" => :yosemite
    sha256 "3a3a1a2872f5ab37a5cc42b29fd0226737a5fbeb56df634aea6a3295016e869a" => :mavericks
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
