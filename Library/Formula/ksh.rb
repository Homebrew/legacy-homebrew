
class Ksh < Formula
  desc "ksh93, the KornShell"
  homepage "http://www.kornshell.com"
  url "https://opensource.apple.com/source/ksh/ksh-23/ast-ksh.2012-08-01.tgz",
    :using => :nounzip
  mirror "https://www.mirrorservice.org/pub/pkgsrc/distfiles/ast-ksh.2012-08-01.tgz"
  version "93u+" # Versioning scheme: + means "+ patches", - means "beta/alpha".
  sha256 "e6192cfa52a6a9fd20618cbaf3fa81f0cc9fd83525500757e83017275e962851"

  bottle do
    cellar :any_skip_relocation
    revision 3
    sha256 "5148e18444c7f1a4e7b71f72982362491aa5581101296acaa6d9c2a782d620b1" => :el_capitan
    sha256 "13f85c7df7f44b68f1e5560c05b61eff8145230d94986537bdee5702c1e72e68" => :yosemite
    sha256 "7c665466fb323fc0cb6ffb87ec9fe1630d75afcd3b12864e2424677473db4924" => :mavericks
  end

  resource "init" do
    url "https://opensource.apple.com/source/ksh/ksh-23/INIT.2012-08-01.tgz"
    mirror "https://www.mirrorservice.org/pub/pkgsrc/distfiles/INIT.2012-08-01.tgz"
    sha256 "c40cf57e9b2186271a9c362a560aa4a6e25ba911a8258ab931d2bbdbce44cfe5"
  end

  def install
    resource("init").stage buildpath
    (buildpath/"lib/package/tgz").install Dir["*.tgz"]
    system "/bin/ksh", "bin/package", "read"

    # Needed due to unusal build system.
    ENV.refurbish_args

    # From Apple"s ksh makefile.
    kshcppdefines = "-DSHOPT_SPAWN=0 -D_ast_int8_t=int64_t -D_lib_memccpy"
    system "/bin/ksh", "bin/package", "make", "CCFLAGS=#{kshcppdefines}"

    bin.install "arch/darwin.i386-64/bin/ksh" => "ksh93"
    bin.install_symlink "ksh93" => "ksh"

    man1.install "arch/darwin.i386-64/man/man1/sh.1" => "ksh93.1"
    man1.install_symlink "ksh93.1" => "ksh.1"
  end

  def caveats; <<-EOS.undent
      We agreed to the Eclipse Public License 1.0 for you.
      If this is unacceptable you should uninstall.
    EOS
  end

  test do
    assert_equal "Hello World!", pipe_output("#{bin}/ksh -e 'echo Hello World!'").chomp
  end
end
