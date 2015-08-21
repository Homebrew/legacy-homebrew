class Smlnj < Formula
  desc "Standard ML of New Jersey"
  homepage "http://www.smlnj.org/"
  url "http://smlnj.cs.uchicago.edu/dist/working/110.78/config.tgz"
  version "110.78"
  sha256 "e2dd00b39b00ad892f182ce3f824d1540b0e350f2aee748ca971d44b5d340c05"

  bottle do
    revision 1
    sha256 "bc060f3794995fe9919d77a606de7084654d27b6185b51725db78cdf62736f4e" => :yosemite
    sha256 "d65bdd75825461dc6fd3f15f50de7ebe339b0644e7cb21132b0f2cd742cd293f" => :mavericks
    sha256 "ae8daf8491c3b2d6d2b12ce101fba322791591065b69129ff734325a1a1be063" => :mountain_lion
  end

  resource "cm" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.78/cm.tgz"
    version "110.78"
    sha256 "1d8911cf0b3b93dd5d62334d7be090497b88d87e8924623fc36311498d3ca345"
  end

  resource "compiler" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.78/compiler.tgz"
    version "110.78"
    sha256 "e2dd6a1bdd5953958262fcbf385633611ff169dc4c272a568f3551c43e4d49d4"
  end

  resource "runtime" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.78/runtime.tgz"
    version "110.78"
    sha256 "5e9f750991f43ce6bd57f1877c579ea778f24d612974260c27bf216857d88bdf"
  end

  resource "system" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.78/system.tgz"
    version "110.78"
    sha256 "49311750b735357c59d30c4bf79d2b4bdbe2426319bdd196b5ac4bc647a5b1c9"
  end

  resource "bootstrap" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.78/boot.x86-unix.tgz"
    version "110.78"
    sha256 "aad8994871dd9e4669ed8f4af3e35ed61f34763f1933839bedb65132c7118da7"
  end

  resource "mlrisc" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.78/MLRISC.tgz"
    version "110.78"
    sha256 "1bf07d6cf2307b69e68a87be1880ae1a9d79a0c76fc980c715869186e7e47845"
  end

  resource "lib" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.78/smlnj-lib.tgz"
    version "110.78"
    sha256 "590e261b94140d4d4091c93b61d077995925dd98148e9d31e680f781d1e5b6d3"
  end

  resource "ckit" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.78/ckit.tgz"
    version "110.78"
    sha256 "d7f2f5866cc226fd1232f568c62b0d691d57cb0388b4e2e26480f82e37201cdb"
  end

  resource "nlffi" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.78/nlffi.tgz"
    version "110.78"
    sha256 "008edc563f192194c4eec7a3f9ecd97ddac6363bf070ea84f25c8ce5620f7ab2"
  end

  resource "cml" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.78/cml.tgz"
    version "110.78"
    sha256 "1fbe7370fde5b7f222fab9246b35773f24778edd9d91145b82563fa5b791ca61"
  end

  resource "exene" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.78/eXene.tgz"
    version "110.78"
    sha256 "bc5e74f736320da957cbfe4800c618442e9bd68617cf4e2f16e05444bc5893da"
  end

  resource "ml-lpt" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.78/ml-lpt.tgz"
    version "110.78"
    sha256 "38b6766f4112670440417005db2cd76a3ccf38014aeba129a491371c687b6209"
  end

  resource "ml-lex" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.78/ml-lex.tgz"
    version "110.78"
    sha256 "e5f756524e2d5ed1b0580d843ae59dcb1d71c5e671bcc07d7df83a5e5a6b3a50"
  end

  resource "ml-yacc" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.78/ml-yacc.tgz"
    version "110.78"
    sha256 "a646e783ffff2b566e4013944c01cbcfbb6fad346d552fe5ea7a90d53c48c752"
  end

  resource "ml-burg" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.78/ml-burg.tgz"
    version "110.78"
    sha256 "22b971dffe3e14ee69fef30ddc3c4d50fef43a4c8874a86abeeecdf684f7560d"
  end

  resource "pgraph" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.78/pgraph.tgz"
    version "110.78"
    sha256 "69c803e79e38e23b8de055ef307545a012daca0636be5f3bd8cea810b6620ba6"
  end

  resource "trace-debug-profile" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.78/trace-debug-profile.tgz"
    version "110.78"
    sha256 "93c22700a52fe99fce363fcd52f22f0161f591b84cba360bba7ac8b7c7d39a2b"
  end

  resource "heap2asm" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.78/heap2asm.tgz"
    version "110.78"
    sha256 "4f821f18f930eaf790f2dbb1bd66356fb72b8ce17bd3b8310ff48c6eeaea75ee"
  end

  resource "c" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.78/smlnj-c.tgz"
    version "110.78"
    sha256 "2d48e6466314c7563f7f7b07700f3d93430c8082199874de0b1ff25d1a536821"
  end

  # Pings `unname -r` to determine OS X version & panics that
  # it doesn't recognise El Capitan. Already fixed upstream, but
  # patch doesn't apply cleanly from trunk.
  # http://smlnj-gforge.cs.uchicago.edu/scm/viewvc.php?view=rev&root=smlnj&revision=4073
  patch :DATA

  def install
    ENV.deparallelize
    ENV.m32 # does not build 64-bit

    # Build in place
    root = prefix/"SMLNJ_HOME"
    cd ".."
    root.install "config"
    cd root

    # Rewrite targets list (default would be too minimalistic)
    rm "config/targets"
    Pathname.new("config/targets").write targets

    # Download and extract all the sources for the base system
    %w[cm compiler runtime system].each do |name|
      resource(name).stage { cp_r pwd, root/"base" }
    end

    # Download the remaining packages that go directly into the root
    %w[
      bootstrap mlrisc lib ckit nlffi
      cml exene ml-lpt ml-lex ml-yacc ml-burg pgraph
      trace-debug-profile heap2asm c
    ].each do |name|
      resource(name).stage { cp_r pwd, root }
    end

    inreplace root/"base/runtime/objs/mk.x86-darwin", "/usr/bin/as", "as"

    # Orrrr, don't mess with our PATH. Superenv carefully sets that up.
    inreplace root/"base/runtime/config/gen-posix-names.sh", "PATH=/bin:/usr/bin", "# do not hardcode the path"
    inreplace root/"base/runtime/config/gen-posix-names.sh", "/usr/include", "#{MacOS.sdk_path}/usr/include" unless MacOS::CLT.installed?

    system "config/install.sh"

    %w[
      sml heap2asm heap2exec ml-antlr
      ml-build ml-burg ml-lex ml-makedepend
      ml-nlffigen ml-ulex ml-yacc
    ].each { |e| bin.install_symlink root/"bin/#{e}" }
  end

  def targets
    <<-EOS.undent
      request ml-ulex
      request ml-ulex-mllex-tool
      request ml-lex
      request ml-lex-lex-ext
      request ml-yacc
      request ml-yacc-grm-ext
      request ml-antlr
      request ml-lpt-lib
      request ml-burg
      request smlnj-lib
      request tdp-util
      request cml
      request cml-lib
      request mlrisc
      request ml-nlffigen
      request ml-nlffi-lib
      request mlrisc-tools
      request eXene
      request pgraph-util
      request ckit
      request heap2asm
    EOS
  end

  test do
    system bin/"ml-nlffigen"
    assert File.exist?("NLFFI-Generated/nlffi-generated.cm")
  end
end

__END__

diff --git a/_arch-n-opsys b/_arch-n-opsys
index 2da504c..020e1a0 100644
--- a/_arch-n-opsys
+++ b/_arch-n-opsys
@@ -47,6 +47,7 @@ case `uname -s` in
	  12*) OPSYS=darwin;  HEAP_OPSYS=darwin ;; # MacOS X 10.8 Mountain Lion
	  13*) OPSYS=darwin;  HEAP_OPSYS=darwin ;; # MacOS X 10.9 Mavericks
	  14*) OPSYS=darwin;  HEAP_OPSYS=darwin ;; # MacOS X 10.10 Yosemite
+	  15*) OPSYS=darwin;  HEAP_OPSYS=darwin ;; # MacOS X 10.11 El Capitan
	  *) exit 1;;
	esac;;
     esac
