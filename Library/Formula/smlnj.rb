require 'formula'

class Smlnj < Formula
  homepage 'http://www.smlnj.org/'
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.76/config.tgz'
  sha1 '49ce2968bb1a4a41b56f55ed1de41c662b88bc85'
  version '110.76'

  resource 'cm' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.76/cm.tgz'
    version '110.76'
    sha1 'a5d5178ba2f5f04fd1e5c9211b39f8593b5f7701'
  end

  resource 'compiler' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.76/compiler.tgz'
    version '110.76'
    sha1 '9192bee6da808964c71cc7499068f539205bdd39'
  end

  resource 'runtime' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.76/runtime.tgz'
    version '110.76'
    sha1 '3d1799fd160a9f24f13cbc44587822fe70b031eb'
  end

  resource 'system' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.76/system.tgz'
    version '110.76'
    sha1 '59f24b486279572d43e6661d8b4ebd5f91ec6a7b'
  end

  resource 'bootstrap' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.76/boot.x86-unix.tgz'
    version '110.76'
    sha1 'c4d530538257689a0e146acf998bea9d3370aa27'
  end

  resource 'mlrisc' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.76/MLRISC.tgz'
    version '110.76'
    sha1 '3f9dc0f99f158b2e2fbbdab39ce1c2375a73e248'
  end

  resource 'lib' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.76/smlnj-lib.tgz'
    version '110.76'
    sha1 'f4fc0f56436bec676219004ef73f707430811147'
  end

  resource 'ckit' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.76/ckit.tgz'
    version '110.76'
    sha1 '82b149381119138de350e28dfb3323e7c47ff8d4'
  end

  resource 'nlffi' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.76/nlffi.tgz'
    version '110.76'
    sha1 'cfbd0ae158cef4f22fa968b16d94af0f93eb2fde'
  end

  resource 'cml' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.76/cml.tgz'
    version '110.76'
    sha1 '61d1b0458410cb7f84c2ee9c66798ad86ac72226'
  end

  resource 'exene' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.76/eXene.tgz'
    version '110.76'
    sha1 'd0b2fc0c44de4a25f342f7e2789804fcd2f48ee7'
  end

  resource 'ml-lpt' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.76/ml-lpt.tgz'
    version '110.76'
    sha1 'cb99915ce853929e264afa304b6295e28de8f927'
  end

  resource 'ml-lex' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.76/ml-lex.tgz'
    version '110.76'
    sha1 '8298bd3b1e480453f700659334cc086838e33cf0'
  end

  resource 'ml-yacc' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.76/ml-yacc.tgz'
    version '110.76'
    sha1 'd6f565c1f64ab485d2f96a3d725f73a5cf758106'
  end

  resource 'ml-burg' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.76/ml-burg.tgz'
    version '110.76'
    sha1 '27e8442b0aefa58d0ea43bc8f3b47cb1baab1fdf'
  end

  resource 'pgraph' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.76/pgraph.tgz'
    version '110.76'
    sha1 'a374b6950c133e9568d0663d906acce1845f33e3'
  end

  resource 'trace-debug-profile' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.76/trace-debug-profile.tgz'
    version '110.76'
    sha1 '43127a065f22f026fe960580dded77897626cd27'
  end

  resource 'heap2asm' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.76/heap2asm.tgz'
    version '110.76'
    sha1 'aeee4614843893d73ff2c129ec3683d38d1d388e'
  end

  resource 'c' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.76/smlnj-c.tgz'
    version '110.76'
    sha1 'b05de86f0596da6400e4d9aad4ec3a5ff7393e0f'
  end

  def install
    ENV.deparallelize
    ENV.m32 # does not build 64-bit

    # Build in place
    root = prefix/"SMLNJ_HOME"
    cd '..'
    root.install 'config'
    cd root

    # Rewrite targets list (default would be too minimalistic)
    rm 'config/targets'
    Pathname.new('config/targets').write targets

    # Download and extract all the sources for the base system
    %w{cm compiler runtime system}.each do |name|
      resource(name).stage { cp_r pwd, root/'base' }
    end

    # Download the remaining packages that go directly into the root
    %w{
      bootstrap mlrisc lib ckit nlffi
      cml exene ml-lpt ml-lex ml-yacc ml-burg pgraph
      trace-debug-profile heap2asm c
    }.each do |name|
      resource(name).stage { cp_r pwd, root }
    end

    inreplace root/'base/runtime/objs/mk.x86-darwin', '/usr/bin/as', 'as'

    # Orrrr, don't mess with our PATH. Superenv carefully sets that up.
    inreplace root/'base/runtime/config/gen-posix-names.sh','PATH=/bin:/usr/bin', '# do not hardcode the path'
    inreplace root/'base/runtime/config/gen-posix-names.sh', '/usr/include', "#{MacOS.sdk_path}/usr/include" unless MacOS::CLT.installed?

    system 'config/install.sh'

    %w{
      sml heap2asm heap2exec ml-antlr
      ml-build ml-burg ml-lex ml-makedepend
      ml-nlffigen ml-ulex ml-yacc
    }.each { |e| bin.install_symlink root/"bin/#{e}" }
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
end
