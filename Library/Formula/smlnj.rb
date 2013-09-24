require 'formula'

class Smlnj < Formula
  homepage 'http://www.smlnj.org/'
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/config.tgz'
  sha1 '527cb179b48abcf1463089d168b171fd05eb814d'
  version '110.75'

  resource 'cm' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/cm.tgz'
    version '110.75'
    sha1 'a4310413102c5649ed43d92962ffa307ebec4a39'
  end

  resource 'compiler' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/compiler.tgz'
    version '110.75'
    sha1 'efd03a1cc84104c22776f56dca67e0ae5e9145e8'
  end

  resource 'runtime' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/runtime.tgz'
    version '110.75'
    sha1 'dd81ce2963ca0ea4b1e92b22c7587d5ae64783f8'
  end

  resource 'system' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/system.tgz'
    version '110.75'
    sha1 '0f7536bbdcd6d1584f4dcbf3b30a553d98fb0cb1'
  end

  resource 'bootstrap' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/boot.x86-unix.tgz'
    version '110.75'
    sha1 '0e459e33f54811750a42311a22bc4572ab16ebcb'
  end

  resource 'mlrisc' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/MLRISC.tgz'
    version '110.75'
    sha1 '041b6463d98d0effa0afc457fc5b09e74f081b85'
  end

  resource 'lib' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/smlnj-lib.tgz'
    version '110.75'
    sha1 '33f4d3a8dc653cd015ed15a27776dd0e3f2fbb04'
  end

  resource 'ckit' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/ckit.tgz'
    version '110.75'
    sha1 '0dbca80174f969a549d85ef3e15a4a8ecce7ed22'
  end

  resource 'nlffi' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/nlffi.tgz'
    version '110.75'
    sha1 'b881390f58df7bbc5d84c45eec20af7fcfbfa40c'
  end

  resource 'cml' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/cml.tgz'
    version '110.75'
    sha1 '8938aa0685453c16f57bae23e96ed23b1409f419'
  end

  resource 'exene' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/eXene.tgz'
    version '110.75'
    sha1 'f8608de797634faaad632fbdfd43838c4de85e42'
  end

  resource 'ml-lpt' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/ml-lpt.tgz'
    version '110.75'
    sha1 'd0b68f304a5e29173a9599a3959c12e84ea479ee'
  end

  resource 'ml-lex' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/ml-lex.tgz'
    version '110.75'
    sha1 '6557d928f85b28938d4c299925835a6d5eb1e68b'
  end

  resource 'ml-yacc' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/ml-yacc.tgz'
    version '110.75'
    sha1 '1bec52fbc6557dcd7d4363a1ae13be540bfc89a5'
  end

  resource 'ml-burg' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/ml-burg.tgz'
    version '110.75'
    sha1 '202f62c604e6d11b0ebed82ce78210a8e5224a9d'
  end

  resource 'pgraph' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/pgraph.tgz'
    version '110.75'
    sha1 '7b6425de5ca1648caf230dea5e8db34f90b481c9'
  end

  resource 'trace-debug-profile' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/trace-debug-profile.tgz'
    version '110.75'
    sha1 'c828e9d2728171a5d087a41fcbb923ac460a9d50'
  end

  resource 'heap2asm' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/heap2asm.tgz'
    version '110.75'
    sha1 '49c81c4343db2095fe7c28ae5ef40086d225421c'
  end

  resource 'c' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/smlnj-c.tgz'
    version '110.75'
    sha1 'adbc3874f8715d53bc1f032047c3289cff0af8e9'
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
