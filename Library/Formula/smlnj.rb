require 'formula'

class Smlnj < Formula
  desc "Standard ML of New Jersey"
  homepage 'http://www.smlnj.org/'
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.78/config.tgz'
  sha1 '92c108bbfe839c5a285fd222f571db9bda84d762'
  version '110.78'

  bottle do
    sha256 "faa649b3781c84abd7f83855ecaa566c26e1a01a80df746ceaf762f07bdb3205" => :yosemite
    sha256 "2ec8a12dfd01d80bcab51c736a8525800e135ede2f52a2ecf157268383e315c0" => :mavericks
    sha256 "38ec6f36214fb451c0d69b4d05876a1d87a2b5cc39b9aa24935a86b65485c5d9" => :mountain_lion
  end

  resource 'cm' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.78/cm.tgz'
    version '110.78'
    sha1 'e8c1a752102fc0451ceee765a52aaa9addc10698'
  end

  resource 'compiler' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.78/compiler.tgz'
    version '110.78'
    sha1 'dabe7359593c992ec087d09069acc6bb2c18fa93'
  end

  resource 'runtime' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.78/runtime.tgz'
    version '110.78'
    sha1 'e6638ae38fbbe57829199ec3ff048cd8a736641f'
  end

  resource 'system' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.78/system.tgz'
    version '110.78'
    sha1 '1a9adb81110442064548a07a239166f892d17f5d'
  end

  resource 'bootstrap' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.78/boot.x86-unix.tgz'
    version '110.78'
    sha1 'd54428d5546c410fb443a2853cb14ecc67d91cfa'
  end

  resource 'mlrisc' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.78/MLRISC.tgz'
    version '110.78'
    sha1 '2def41687b12196e7062d2edaf86fbccd93c8a9e'
  end

  resource 'lib' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.78/smlnj-lib.tgz'
    version '110.78'
    sha1 'ed75fdd94facad96a3c2f92709c5004c7d674a02'
  end

  resource 'ckit' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.78/ckit.tgz'
    version '110.78'
    sha1 '444f2f6fe68a872f74c320ffa33798704463b79d'
  end

  resource 'nlffi' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.78/nlffi.tgz'
    version '110.78'
    sha1 '11e22aea7215e2769bf4f63e06e9c63f6d888976'
  end

  resource 'cml' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.78/cml.tgz'
    version '110.78'
    sha1 'de402a91159b0f6a28e52dc11b4234ce354435cf'
  end

  resource 'exene' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.78/eXene.tgz'
    version '110.78'
    sha1 '3c005cd0ea253f560a077373a0efdeb85e2eca3c'
  end

  resource 'ml-lpt' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.78/ml-lpt.tgz'
    version '110.78'
    sha1 '5cd325db5994d173a841625612dbbd6775a8f9af'
  end

  resource 'ml-lex' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.78/ml-lex.tgz'
    version '110.78'
    sha1 'd818d511e54c3969b0a5f2900a9a0390189e0ae6'
  end

  resource 'ml-yacc' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.78/ml-yacc.tgz'
    version '110.78'
    sha1 '2ed8e80fd040e6c7fe3ce90ed045791768c8e128'
  end

  resource 'ml-burg' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.78/ml-burg.tgz'
    version '110.78'
    sha1 '4e1a6df602b0f5c1a7fa68937deed4f2220b40a1'
  end

  resource 'pgraph' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.78/pgraph.tgz'
    version '110.78'
    sha1 '66bf762f22233111cd6bbf2ca3bc8917ebcbf01b'
  end

  resource 'trace-debug-profile' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.78/trace-debug-profile.tgz'
    version '110.78'
    sha1 'e27812854feeb1df89d20a06763fa1c439d31ef5'
  end

  resource 'heap2asm' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.78/heap2asm.tgz'
    version '110.78'
    sha1 '6feea8fc9234272b624ad97208cb39d194f12557'
  end

  resource 'c' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.78/smlnj-c.tgz'
    version '110.78'
    sha1 '5992da53069dbb9ba0e9e826e781ab6c1bc6480c'
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
