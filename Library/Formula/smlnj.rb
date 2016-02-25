class Smlnj < Formula
  desc "Standard ML of New Jersey"
  homepage "http://www.smlnj.org/"
  url "http://smlnj.cs.uchicago.edu/dist/working/110.79/config.tgz"
  version "110.79"
  sha256 "ab2302580e187f6ec1ab54355260b8b614fb8c94ff68847c5b40fcae8b872aea"

  bottle do
    revision 1
    sha256 "148c036610f5a5e21543254c9e3af39ea9dfe73b8ed83b999ab70e492ed516d1" => :el_capitan
    sha256 "bc060f3794995fe9919d77a606de7084654d27b6185b51725db78cdf62736f4e" => :yosemite
    sha256 "d65bdd75825461dc6fd3f15f50de7ebe339b0644e7cb21132b0f2cd742cd293f" => :mavericks
    sha256 "ae8daf8491c3b2d6d2b12ce101fba322791591065b69129ff734325a1a1be063" => :mountain_lion
  end

  resource "cm" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.79/cm.tgz"
    sha256 "bf558d31be2935f974cad65e25d7b2dc1320cb1d7dd5f0726d8e87b961388f9c"
  end

  resource "compiler" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.79/compiler.tgz"
    sha256 "bc127b1d6b5af3802d43c0ca741a24a81c98ffff6f9cb948f57548f84e8a3c00"
  end

  resource "runtime" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.79/runtime.tgz"
    sha256 "208f40f720873af65067d48a6757594b3f300918951be77dfb6dd922de6f5b51"
  end

  resource "system" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.79/system.tgz"
    sha256 "712a87f7409103d89f2afcd1dc55e7f71d5f55d7a0493543b96054644b254302"
  end

  resource "bootstrap" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.79/boot.x86-unix.tgz"
    sha256 "f8a3cc665503400cf9941b4475ccfd485c157bdc25fb45b8ce34423a61236a5a"
  end

  resource "mlrisc" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.79/MLRISC.tgz"
    sha256 "e8e828fc8056a60ea470486635c2da3329f0104e3559693eb2c42fe7cf7d03a7"
  end

  resource "lib" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.79/smlnj-lib.tgz"
    sha256 "09444d739f15323b4039617b38968fd494aba948b0c5b9a9600126f88760333b"
  end

  resource "ckit" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.79/ckit.tgz"
    sha256 "fc1e3d9a137dfd81df5122e2b64f6f64cdae88c6d0c16e246ad82b8e6f711dfd"
  end

  resource "nlffi" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.79/nlffi.tgz"
    sha256 "db24b637847bd6052e822fafb370bf545b09c0a15078c78169a0f946e3a98494"
  end

  resource "cml" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.79/cml.tgz"
    sha256 "e2f49aac1eebdac7ce206dec28dc4dd347f203e752808279347069fa8bc17485"
  end

  resource "exene" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.79/eXene.tgz"
    sha256 "cf275b8239c5adbe74c21853516811229107b3f9d171b757aa4157de8b42d493"
  end

  resource "ml-lpt" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.79/ml-lpt.tgz"
    sha256 "f5f08bc46e83d4ca825e1b921630b1855f51bbe4bada5d7d48d58fe3c43e1a85"
  end

  resource "ml-lex" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.79/ml-lex.tgz"
    sha256 "cb98d2f221bfba16d852ebed73c0540395fa240034d35543b046a22d428ec551"
  end

  resource "ml-yacc" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.79/ml-yacc.tgz"
    sha256 "f3c04f458024be9d832906bbd4143a59a7e3b50d66cb7488ebb3f380d772b136"
  end

  resource "ml-burg" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.79/ml-burg.tgz"
    sha256 "2d408316bf26e98e5df9a37e84a018db07149c7a7287e894ba33ccf8150abfac"
  end

  resource "pgraph" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.79/pgraph.tgz"
    sha256 "5bc870302d38fdd24e54be754cd50b2dbd7268a6269b35b4c228d97f2834e095"
  end

  resource "trace-debug-profile" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.79/trace-debug-profile.tgz"
    sha256 "3c6a87fd658a79f722bb510f834545157b13a46a16e9c78667d7312f36a3914b"
  end

  resource "heap2asm" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.79/heap2asm.tgz"
    sha256 "d3bdb537ae41111064fb2993ff0924d3555096a3d108210da249d3d902d7d473"
  end

  resource "c" do
    url "http://smlnj.cs.uchicago.edu/dist/working/110.79/smlnj-c.tgz"
    sha256 "c0f934214ebd214e68c7f2b5007f7d97c3bb230dd3810d261ce57d68434e28f7"
  end

  def install
    ENV.deparallelize
    ENV.m32 # does not build 64-bit

    # Build in place
    root = prefix/"SMLNJ_HOME"
    root.mkpath
    cp_r buildpath, root/"config"

    # Rewrite targets list (default would be too minimalistic)
    rm root/"config/targets"
    (root/"config/targets").write targets

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
    inreplace root/"base/runtime/config/gen-posix-names.sh",
      "PATH=/bin:/usr/bin", "# do not hardcode the path"
    inreplace root/"base/runtime/config/gen-posix-names.sh",
      "/usr/include", "#{MacOS.sdk_path}/usr/include" unless MacOS::CLT.installed?

    cd root do
      system "config/install.sh"
    end

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
