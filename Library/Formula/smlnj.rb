require 'formula'

# SML/NJ consists of several source archives and we want to cache them instead
# of config downloading then on demand.

class SmlnjCm < Formula
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/cm.tgz'
  version '110.75'
  sha1 'a4310413102c5649ed43d92962ffa307ebec4a39'
end

class SmlnjCompiler < Formula
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/compiler.tgz'
  version '110.75'
  sha1 'efd03a1cc84104c22776f56dca67e0ae5e9145e8'
end

class SmlnjRuntime < Formula
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/runtime.tgz'
  version '110.75'
  sha1 'dd81ce2963ca0ea4b1e92b22c7587d5ae64783f8'
end

class SmlnjSystem < Formula
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/system.tgz'
  version '110.75'
  sha1 '0f7536bbdcd6d1584f4dcbf3b30a553d98fb0cb1'
end

class SmlnjBootstrap < Formula
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/boot.x86-unix.tgz'
  version '110.75'
  sha1 '0e459e33f54811750a42311a22bc4572ab16ebcb'
end

class SmlnjMLRISC < Formula
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/MLRISC.tgz'
  version '110.75'
  sha1 '041b6463d98d0effa0afc457fc5b09e74f081b85'
end

class SmlnjLib < Formula
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/smlnj-lib.tgz'
  version '110.75'
  sha1 '33f4d3a8dc653cd015ed15a27776dd0e3f2fbb04'
end

class SmlnjCkit < Formula
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/ckit.tgz'
  version '110.75'
  sha1 '0dbca80174f969a549d85ef3e15a4a8ecce7ed22'
end

class SmlnjNlffi < Formula
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/nlffi.tgz'
  version '110.75'
  sha1 'b881390f58df7bbc5d84c45eec20af7fcfbfa40c'
end

class SmlnjCml < Formula
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/cml.tgz'
  version '110.75'
  sha1 '8938aa0685453c16f57bae23e96ed23b1409f419'
end

class SmlnjExene < Formula
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/eXene.tgz'
  version '110.75'
  sha1 'f8608de797634faaad632fbdfd43838c4de85e42'
end

class SmlnjMlLpt < Formula
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/ml-lpt.tgz'
  version '110.75'
  sha1 'd0b68f304a5e29173a9599a3959c12e84ea479ee'
end

class SmlnjMlLex < Formula
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/ml-lex.tgz'
  version '110.75'
  sha1 '6557d928f85b28938d4c299925835a6d5eb1e68b'
end

class SmlnjMlYacc < Formula
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/ml-yacc.tgz'
  version '110.75'
  sha1 '1bec52fbc6557dcd7d4363a1ae13be540bfc89a5'
end

class SmlnjMlBurg < Formula
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/ml-burg.tgz'
  version '110.75'
  sha1 '202f62c604e6d11b0ebed82ce78210a8e5224a9d'
end

class SmlnjPgraph < Formula
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/pgraph.tgz'
  version '110.75'
  sha1 '7b6425de5ca1648caf230dea5e8db34f90b481c9'
end

class SmlnjTracheDebugProfile < Formula
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/trace-debug-profile.tgz'
  version '110.75'
  sha1 'c828e9d2728171a5d087a41fcbb923ac460a9d50'
end

class SmlnjHeap2asm < Formula
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/heap2asm.tgz'
  version '110.75'
  sha1 '49c81c4343db2095fe7c28ae5ef40086d225421c'
end

class SmlnjC < Formula
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/smlnj-c.tgz'
  version '110.75'
  sha1 'adbc3874f8715d53bc1f032047c3289cff0af8e9'
end

class Smlnj < Formula
  homepage 'http://www.smlnj.org/'
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.75/config.tgz'
  sha1 '527cb179b48abcf1463089d168b171fd05eb814d'
  version '110.75'

  def install
    ENV.deparallelize

    # This software is not yet 64bit ready. Hello? It's almost 2013!
    ENV.m32

    # Build in place
    root = (prefix/"SMLNJ_HOME")
    cd '..'
    root.install 'config'
    cd root

    # Rewrite targets list (default would be too minimalistic)
    rm('config/targets')
    Pathname.new('config/targets').write targets

    # Download and extract all the sources for the base system
    SmlnjCm.new.brew { cp_r(pwd, root+'base') }
    SmlnjCompiler.new.brew { cp_r(pwd, root+'base') }
    SmlnjRuntime.new.brew{ cp_r(pwd, root+'base') }
    SmlnjSystem.new.brew{ cp_r(pwd, root+'base') }

    # Download the remaining packages that go directly into the root
    SmlnjBootstrap.new.brew{ cp_r(pwd, root) }
    SmlnjMLRISC.new.brew{ cp_r(pwd, root) }
    SmlnjLib.new.brew{ cp_r(pwd, root) }
    SmlnjCkit.new.brew{ cp_r(pwd, root) }
    SmlnjNlffi.new.brew{ cp_r(pwd, root) }
    SmlnjCml.new.brew{ cp_r(pwd, root) }
    SmlnjExene.new.brew{ cp_r(pwd, root) }
    SmlnjMlLpt.new.brew{ cp_r(pwd, root) }
    SmlnjMlLex.new.brew{ cp_r(pwd, root) }
    SmlnjMlYacc.new.brew{ cp_r(pwd, root) }
    SmlnjMlBurg.new.brew{ cp_r(pwd, root) }
    SmlnjPgraph.new.brew{ cp_r(pwd, root) }
    SmlnjTracheDebugProfile.new.brew{ cp_r(pwd, root) }
    SmlnjHeap2asm.new.brew{ cp_r(pwd, root) }
    SmlnjC.new.brew{ cp_r(pwd, root) }

    ohai "Fix hard-coded path to `as`"
    inreplace root/'base/runtime/objs/mk.x86-darwin', '/usr/bin/as', 'as'

    # Orrrr, don't mess with our PATH. Superenv carefully sets that up.
    inreplace root/'base/runtime/config/gen-posix-names.sh', 'PATH=/bin:/usr/bin', '# do not hardcode the path'
    inreplace root/'base/runtime/config/gen-posix-names.sh', '/usr/include', "#{MacOS.sdk_path}/usr/include" unless MacOS::CLT.installed?

    system 'config/install.sh'

    # And these should be in the PATH, so we put then into bin
    bin.mkpath
    [ 'sml',
      'heap2asm',
      'heap2exec',
      'ml-antlr',
      'ml-build',
      'ml-burg',
      'ml-lex',
      'ml-makedepend',
      'ml-nlffigen',
      'ml-ulex',
      'ml-yacc'
    ].each{ |e| ln_s(root/"bin/#{e}", bin/e) }
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
