require 'formula'

def build_clang?
  ARGV.include? '--with-clang'
end
def all_targets?
  ARGV.include? '--enable-all-targets'
end
def ocaml_binding?
  ARGV.include? '--enable-ocaml-binding'
end

class Clang <Formula
  url       'http://llvm.org/releases/2.8/clang-2.8.tgz'
  homepage  'http://llvm.org/'
  md5       '10e14c901fc3728eecbd5b829e011b59'
  head      'http://llvm.org/svn/llvm-project/cfe/trunk', :using => :svn
end

class Llvm <Formula
  url       'http://llvm.org/releases/2.8/llvm-2.8.tgz'
  homepage  'http://llvm.org/'
  md5       '220d361b4d17051ff4bb21c64abe05ba'
  head      'http://llvm.org/svn/llvm-project/llvm/trunk', :using => :svn

  def options
    [
        ['--with-clang', 'Build and install clang and clang static analyzer'],
        ['--all-targets', 'Build non-host targets'],
        ['--enable-ocaml-binding', 'Enable Ocaml language binding']
    ]
  end

  depends_on 'objective-caml' if ocaml_binding?

  skip_clean :all

  def install
    fails_with_llvm "The llvm-gcc in Xcode is outdated to compile current version of llvm"

    if build_clang?
      clang_dir = Pathname(Dir.pwd)+'tools/clang'
      Clang.new('clang').brew { clang_dir.install Dir['*'] }
    end

    source_dir = Pathname(Dir.pwd)
    build_dir = source_dir+'build'
    mkdir build_dir
    cd build_dir do
      build_dir = Pathname(Dir.pwd)
      system "#{source_dir}/configure", "--prefix=#{prefix}",
                            "--disable-assertions",
                            "--enable-bindings=#{ocaml_binding? ? 'ocaml':'none'}",
                            "--enable-libffi",
                            "--enable-optimized",
                            "--enable-shared",
                            "--enable-targets=#{all_targets? ? 'all':'host-only'}"
      system "make"
      system "make install"
    end

    # Install files in LLVM_SRC_DIR and LLVM_OBJ_DIR, they're necessary for llvm to compile some targets, e.g. llvm-gcc
    # What to copy is roughly the same as MacPorts did
    src_dir = prefix+'lib/llvm/src'
    obj_dir = prefix+'lib/llvm/obj'
    mkdir_p [src_dir, obj_dir]
    cp_r source_dir+'include', src_dir
    rm_r [build_dir+'Release/lib/ocaml'] if ocaml_binding? # duplicated
    cp_r [build_dir+'include', build_dir+'Release', build_dir+'Makefile.config'], obj_dir
    rm_f Dir["#{prefix}/lib/llvm/obj/Release/**/.dir"]
    inreplace ["#{prefix}/bin/llvm-config", "#{obj_dir}/Release/bin/llvm-config"] do |s|
      s.gsub! build_dir, obj_dir
      s.gsub! source_dir, src_dir
    end

    # Install Clang Static Analyzer (http://clang-analyzer.llvm.org/)
    if build_clang?
      dest_dir = libexec+'clang-analyzer'
      for tool in ['scan-build', 'scan-view'] do
        dest_dir.install Dir["tools/clang/tools/#{tool}/*"]
        # create relative symbol link in bin
        ln_s (dest_dir+tool).relative_path_from(bin), bin
      end
      # pre-compile Python scripts
      for opt_arg in ['', '-O'] do
        system "/usr/bin/env python #{opt_arg} -m compileall #{dest_dir}"
      end
      # relative symbol link to clang to prevent the "'clang' executable not found" warning message
      mkdir dest_dir+'bin'
      ln_s bin+'clang', dest_dir+'bin/clang'
      ln_s 'clang', dest_dir+'bin/clang++'
    end
  end

  def caveats; <<-EOS
    If you already have pre-2.8 LLVM installed, then "brew upgrade llvm" might not work. Instead, try:
        $ brew rm llvm
        $ brew install llvm
    EOS
  end

  def test
    system 'llvm-config'
  end
end
