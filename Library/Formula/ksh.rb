
class Ksh < Formula
  desc "ksh93, the KornShell"
  homepage "http://www.kornshell.com"
  url "https://opensource.apple.com/source/ksh/ksh-23/ast-ksh.2012-08-01.tgz",
    :using => :nounzip
  mirror "https://www.mirrorservice.org/pub/pkgsrc/distfiles/ast-ksh.2012-08-01.tgz"
  version "93u+" # Versioning scheme: + means "+ patches", - means "beta/alpha".
  sha256 "e6192cfa52a6a9fd20618cbaf3fa81f0cc9fd83525500757e83017275e962851"

  bottle do
    cellar :any
    revision 2
    sha256 "d644c2bebf9e735a0b1086409fc273f4e28df09ae9a1540490f60f87bac94ddc" => :yosemite
    sha256 "5693e654a561ba55c873574a6853a04f0fd2716219d45e3df5568e211bc3f730" => :mavericks
    sha256 "e5994a299c82f27d5ee78649b2ad5dc5d6202d305fd50ca57809b711ccf0ddc7" => :mountain_lion
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
