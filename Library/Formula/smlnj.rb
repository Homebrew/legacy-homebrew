require 'formula'

class Smlnj < Formula
  homepage 'http://www.smlnj.org/'
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.77/config.tgz'
  sha1 '5ff0c668c2db40fcfbf9ee4e2de30fa5baf04a8b'
  version '110.77'

  resource 'cm' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.77/cm.tgz'
    version '110.77'
    sha1 '83833ebe9d95fc55aca2f7ccccff4100515811fe'
  end

  resource 'compiler' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.77/compiler.tgz'
    version '110.77'
    sha1 'cbb89b260db0798a6789de4e57d47ffbe07c30c5'
  end

  resource 'runtime' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.77/runtime.tgz'
    version '110.77'
    sha1 '36355402a231269a10fe5b919e267c52ea60900c'
  end

  resource 'system' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.77/system.tgz'
    version '110.77'
    sha1 '4888f982a02ccc2336290de4451e89056033c649'
  end

  resource 'bootstrap' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.77/boot.x86-unix.tgz'
    version '110.77'
    sha1 '1b821f982df134ab51aaafb0a44bf6c204a0d84a'
  end

  resource 'mlrisc' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.77/MLRISC.tgz'
    version '110.77'
    sha1 '0aac4f1b1cdbf8e0d36799ed6d15cf52ce60a571'
  end

  resource 'lib' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.77/smlnj-lib.tgz'
    version '110.77'
    sha1 'cc50341c409163e93df148e51631214e5924fdf3'
  end

  resource 'ckit' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.77/ckit.tgz'
    version '110.77'
    sha1 'e622a99888c272dc68527c84821409b470bd95e8'
  end

  resource 'nlffi' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.77/nlffi.tgz'
    version '110.77'
    sha1 '36cfd562540813cd97f805c182f844cbbd7d6c8a'
  end

  resource 'cml' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.77/cml.tgz'
    version '110.77'
    sha1 '24e833d7d1823dbbc746495fa3cd2ad11f08e255'
  end

  resource 'exene' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.77/eXene.tgz'
    version '110.77'
    sha1 'c3fddae262c2d2678fc5f627c8a90825084ab796'
  end

  resource 'ml-lpt' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.77/ml-lpt.tgz'
    version '110.77'
    sha1 '5a0bd3b6fc72ea5fe979db2946efeb6d4dd78b13'
  end

  resource 'ml-lex' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.77/ml-lex.tgz'
    version '110.77'
    sha1 '7996904e21b0bf3bf7521abcec346aed98914d0a'
  end

  resource 'ml-yacc' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.77/ml-yacc.tgz'
    version '110.77'
    sha1 'd7ad6194d1935de976f1590cf8a86a3f36bab23a'
  end

  resource 'ml-burg' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.77/ml-burg.tgz'
    version '110.77'
    sha1 '0a5dda6ea13a542d9432ecca0bf4bba2d911e6a3'
  end

  resource 'pgraph' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.77/pgraph.tgz'
    version '110.77'
    sha1 'b8efe014b28fdbd232497414f2b0b0877d103081'
  end

  resource 'trace-debug-profile' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.77/trace-debug-profile.tgz'
    version '110.77'
    sha1 'c8bd75a2dab6a70dafdee9db96361a581d407b33'
  end

  resource 'heap2asm' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.77/heap2asm.tgz'
    version '110.77'
    sha1 '4a8fcfe8091e6778780be6e75557c45fa6ce3c41'
  end

  resource 'c' do
    url 'http://smlnj.cs.uchicago.edu/dist/working/110.77/smlnj-c.tgz'
    version '110.77'
    sha1 '05c170fa19ed7311acfa20ead3e585e74f7522cb'
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
