require 'formula'

class Clang < Formula
  homepage 'http://llvm.org/'
  url 'http://llvm.org/releases/3.3/cfe-3.3.src.tar.gz'
  sha1 'ccd6dbf2cdb1189a028b70bcb8a22509c25c74c8'
  head 'http://llvm.org/git/clang.git'
end

class CompilerRT < Formula
  homepage 'http://llvm.org/'
  url 'http://llvm.org/releases/3.3/compiler-rt-3.3.src.tar.gz'
  sha1 '745386ec046e3e49742e1ecb6912c560ccd0a002'
  head 'http://llvm.org/git/compiler-rt.git'
end

class Llvm < Formula
  homepage 'http://llvm.org/'
  url 'http://llvm.org/releases/3.3/llvm-3.3.src.tar.gz'
  sha1 'c6c22d5593419e3cb47cbcf16d967640e5cce133'
  head 'http://llvm.org/git/llvm.git'
end

class OCLintXcodebuild < Formula
  head 'https://github.com/oclint/oclint-xcodebuild.git'
end

class OCLintJSONCompilationDatabase < Formula
  head 'https://github.com/oclint/oclint-json-compilation-database.git'
end

class Oclint < Formula
  homepage 'http://oclint.org'
  url 'http://archives.oclint.org/releases/0.7/oclint-0.7-src.tar.gz'
  sha1 '6621d62764a27a4e9c12e0877bb3a927005aaaae'
  head 'https://github.com/oclint/oclint.git'

  depends_on 'cmake' => :build

  option 'with-debug', 'Build in debug mode'

  def install
    Llvm.new("llvm").brew do
      llvm_dir.install Dir['*']
    end

    Clang.new("clang").brew do
      clang_dir.install Dir['*']
    end

    CompilerRT.new("compiler-rt").brew do
      compiler_rt_dir.install Dir['*']
    end

    if build.head?
      OCLintJSONCompilationDatabase.new("oclint-json-compilation-database").brew do
        (buildpath/'oclint-json-compilation-database').install Dir['*']
      end

      OCLintXcodebuild.new("oclint-xcodebuild").brew do
        (buildpath/'oclint-xcodebuild').install Dir['*']
      end
    end

    args = []
    args << "release" unless build.with? 'debug'

    cd oclint_script_dir do
      system './buildClang.sh', *args
      system './buildAll.sh', *args
    end

    cd oclint_release_dir do
      lib.install Dir['lib/clang']
      lib.install Dir['lib/oclint']
      bin.install Dir['bin/*']
    end
  end

  def test
    system "echo \"int main() { return 0; }\" > #{prefix}/test.m"
    system "#{bin}/oclint #{prefix}/test.m -- -c"
  end

  def oclint_script_dir
    buildpath/'oclint-scripts'
  end

  def oclint_release_dir
    buildpath/'build/oclint-release'
  end

  def llvm_dir
    buildpath/'llvm'
  end

  def clang_dir
    llvm_dir/'tools/clang'
  end

  def compiler_rt_dir
    llvm_dir/'projects/compiler-rt'
  end
end
