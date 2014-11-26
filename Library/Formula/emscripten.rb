require "formula"

class Emscripten < Formula
  homepage "https://kripken.github.io/emscripten-site/"
  url "https://github.com/kripken/emscripten/archive/1.27.0.tar.gz"
  sha1 "82feb97e78b87a159c7382b772f62fe5ba2bd0e2"

  bottle do
    sha1 "8441e594986a8e78b586654673f9314f2fecb41e" => :yosemite
    sha1 "412e1f67594b9aa482fefb8642c42678ee96b30b" => :mavericks
    sha1 "87d6bb592ed7e118483e3195767acd2caf50ce2d" => :mountain_lion
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
      url "https://github.com/kripken/emscripten-fastcomp/archive/1.27.0.tar.gz"
      sha1 "77343ed1206a6407bcaafb901f699d4c5d2c3c83"
    end

    resource "fastcomp-clang" do
      url "https://github.com/kripken/emscripten-fastcomp-clang/archive/1.27.0.tar.gz"
      sha1 "53a4ee4482e79117fdd6979f6e2d80d18e2c9dca"
    end
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "node"
  depends_on "closure-compiler" => :optional
  depends_on "yuicompressor"

  def install
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
      # Fix for parsing Mac OS X version numbers >= 10.10
      # https://groups.google.com/forum/#!msg/emscripten-discuss/8gb88R5eyqs/p9_82Wi2pSAJ
      inreplace "Makefile.rules", '10.([0-9])', '10.([0-9]+)'
      inreplace "Makefile.rules", '(10.[0-9])', '(10.[0-9]+)'
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
