class Emscripten < Formula
  homepage "https://kripken.github.io/emscripten-site/"
  url "https://github.com/kripken/emscripten/archive/1.31.0.tar.gz"
  sha256 "d566f743923008ad11768941f51b2079ba4019b0b41c5b3e53c1a655d4f4e5a7"

  bottle do
    sha256 "e152e4c9ae71b8578c094b80cbd030949445a273352ad3d5edd7242d08bf9182" => :yosemite
    sha256 "e0185625c159aa12703b1f23fc5e151772f94386f1360267fcdf657cd2e01c8f" => :mavericks
    sha256 "d68d9eea86d1888354990babf90d0fd5bc44e5f97288c26730056bfe98444ebb" => :mountain_lion
  end

  head do
    url "https://github.com/kripken/emscripten.git", :branch => "incoming"

    resource "fastcomp" do
      url "https://github.com/kripken/emscripten-fastcomp.git", :branch => "incoming"
    end

    resource "fastcomp-clang" do
      url "https://github.com/kripken/emscripten-fastcomp-clang.git", :branch => "incoming"
    end
  end

  stable do
    resource "fastcomp" do
      url "https://github.com/kripken/emscripten-fastcomp/archive/1.31.0.tar.gz"
      sha256 "750de063df3badb04e81bd56a2166ebcf6dfdd4380f59ff9409b4ca37de4b0ab"
    end

    resource "fastcomp-clang" do
      url "https://github.com/kripken/emscripten-fastcomp-clang/archive/1.31.0.tar.gz"
      sha256 "cc2fbaf53e1fe2a00bb5b06f0f75bd8b9a14a86774f76e8a3c69544f732fcacf"
    end
  end

  needs :cxx11

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "node"
  depends_on "closure-compiler" => :optional
  depends_on "yuicompressor"

  def install
    ENV.cxx11
    # OSX doesn't provide a "python2" binary so use "python" instead.
    python2_shebangs = `grep --recursive --files-with-matches ^#!/usr/bin/.*python2$ #{buildpath}`
    python2_shebang_files = python2_shebangs.lines.sort.uniq
    python2_shebang_files.map! {|f| Pathname(f.chomp)}
    python2_shebang_files.reject! &:symlink?
    inreplace python2_shebang_files, %r{^(#!/usr/bin/.*python)2$}, "\\1"

    # All files from the repository are required as emscripten is a collection
    # of scripts which need to be installed in the same layout as in the Git
    # repository.
    libexec.install Dir["*"]

    (buildpath/"fastcomp").install resource("fastcomp")
    (buildpath/"fastcomp/tools/clang").install resource("fastcomp-clang")

    args = [
      "--prefix=#{libexec}/llvm",
      "--enable-optimized",
      "--enable-targets=host,js",
      "--disable-assertions",
      "--disable-bindings",
    ]

    cd "fastcomp" do
      system "./configure", *args
      system "make"
      system "make", "install"
    end

    %w(em++ em-config emar emcc emcmake emconfigure emlink.py emmake
       emranlib emrun emscons).each do |emscript|
      bin.install_symlink libexec/emscript
    end
  end

  test do
    system "#{libexec}/llvm/bin/llvm-config", "--version"
  end

  def caveats; <<-EOS.undent
    Manually set LLVM_ROOT to
      #{opt_libexec}/llvm/bin
    in ~/.emscripten after running `emcc` for the first time.
    EOS
  end
end
