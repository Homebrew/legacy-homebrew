class Emscripten < Formula
  homepage "https://kripken.github.io/emscripten-site/"
  url "https://github.com/kripken/emscripten/archive/1.29.2.tar.gz"
  sha1 "e071af9124e1208cc8fa3e2ff911825fea2ab058"

  bottle do
    sha1 "f73edf45833d349803c37f911eb3be78a8053a5c" => :yosemite
    sha1 "d5c0dc65320975927bffe7bd38c59d6a07ae4f9b" => :mavericks
    sha1 "50318165485dda92de1fea4ccbacc627a4762264" => :mountain_lion
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
      url "https://github.com/kripken/emscripten-fastcomp/archive/1.29.2.tar.gz"
      sha1 "6bf08d975cc431d3be5c4142b3df224629981079"
    end

    resource "fastcomp-clang" do
      url "https://github.com/kripken/emscripten-fastcomp-clang/archive/1.29.2.tar.gz"
      sha1 "8881e3b0a7b4b8851fb4a2ea284761d8414d7401"
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
