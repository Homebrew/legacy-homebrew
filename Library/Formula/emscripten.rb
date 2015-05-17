class Emscripten < Formula
  homepage "https://kripken.github.io/emscripten-site/"
  url "https://github.com/kripken/emscripten/archive/1.32.4.tar.gz"
  sha256 "ddb75dc20cc77d93ed83f2a2c5b7ed220b5bc8d02bdfcdbbbdd95c31cab48266"

  bottle do
    sha256 "63e4ad70b2b93ab4fba0cf8d862563bc5064d92e05232b197da31fdef66c197f" => :yosemite
    sha256 "88857fd77bdcfcf4e524842f86b27da1dbe6400e0191d6e96e09e1c3d159e2cf" => :mavericks
    sha256 "f1e5fb8ec78074727e2fe673d98a5803b7fb4f6ea765b793a4158d3e029bb210" => :mountain_lion
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
      url "https://github.com/kripken/emscripten-fastcomp/archive/1.32.4.tar.gz"
      sha256 "5b29c3f6cb43563762d5b130c506bc5b77b1f57130ef5edbd6e7c48bf5b349fa"
    end

    resource "fastcomp-clang" do
      url "https://github.com/kripken/emscripten-fastcomp-clang/archive/1.32.4.tar.gz"
      sha256 "98d10934d44c66ec610454cd6df0e03c83d975a52dfdb593da91da51073d541b"
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
