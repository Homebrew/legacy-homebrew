class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https://kripken.github.io/emscripten-site/"

  stable do
    url "https://github.com/kripken/emscripten/archive/1.34.6.tar.gz"
    sha256 "630722efebbfd4840ece7dfb8c0bccd714ad9257eab9ac2777db372e4ecf4bb5"

    resource "fastcomp" do
      url "https://github.com/kripken/emscripten-fastcomp/archive/1.34.6.tar.gz"
      sha256 "06a619890de5f40cb4e7ba078c5f053d0df4f58eed30d9afe14f782884088160"
    end

    resource "fastcomp-clang" do
      url "https://github.com/kripken/emscripten-fastcomp-clang/archive/1.34.6.tar.gz"
      sha256 "72eb853cb532daf339a81fbcb86874d3dc29e837acb2c5362044da2b74a4f6df"
    end
  end

  bottle do
    sha256 "fd4d9efb734935996a761128dfaf8a1389d2745ec2bd01d54fab03c2e582bacd" => :el_capitan
    sha256 "99abf785baf4616d5c1a92ffc8540b07faa03a291e4213a960780b4829d4e118" => :yosemite
    sha256 "46794913b20d07af986f34b27e435a26209b426094f5eb596e44052aeefee997" => :mavericks
    sha256 "ff99dde33e1becbb604f6aa3b251b37c494c4da2fecb94916d25e50a6975f8d2" => :mountain_lion
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
    python2_shebang_files.map! { |f| Pathname(f.chomp) }
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
      "--disable-bindings"
    ]

    cd "fastcomp" do
      system "./configure", *args
      system "make"
      system "make", "install"
    end

    %w[em++ em-config emar emcc emcmake emconfigure emlink.py emmake
       emranlib emrun emscons].each do |emscript|
      bin.install_symlink libexec/emscript
    end
  end

  def caveats; <<-EOS.undent
    Manually set LLVM_ROOT to
      #{opt_libexec}/llvm/bin
    in ~/.emscripten after running `emcc` for the first time.
    EOS
  end

  test do
    system "#{libexec}/llvm/bin/llvm-config", "--version"
  end
end
