require 'formula'

class ClangAnalyzer < Formula
  homepage 'http://clang-analyzer.llvm.org/'
  url 'http://clang-analyzer.llvm.org/downloads/checker-276.tar.bz2'
  sha1 'cee77e489653a33ca172a673a9443f99fe3e02d0'

  def install
    libexec.install Dir['*']

    bin.install_symlink "#{libexec}/scan-view"  => 'scan-view'
    bin.install_symlink "#{libexec}/scan-build" => 'scan-build'
  end

  def test
    mktemp do
      (Pathname.pwd + 'scan-build-test.c').write <<-EOS.undent
        int main(int argc, char **argv)
        {
            return 0;
        }
      EOS

      (Pathname.pwd + 'Makefile').write <<-EOS.undent
        CC=/bin/false
        all:
        \t$(CC) scan-build-test.c
      EOS

      system 'scan-build', 'make', '-e'
    end
  end
end
