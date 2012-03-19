require 'formula'

class ClangAnalyzer < Formula
  homepage 'http://clang-analyzer.llvm.org/'
  url 'http://bit.ly/xETQF0'
  md5 'e0e65abb28b1ade15c1fd66fdc34695c'
  version '262'

  def install
    # put everything into libexec because of the potentially conflicting clang
    # compiler that is bundled with the clang-analyzer distribution
    libexec.install Dir['*']

    # Now create proxy scripts to exec the real scan-build and scan-view perl
    # scripts.  Can't just symlink into bin because homebrew will complain about
    # non-executables in that directory.
    (bin+'scan-build').write <<-EOS.undent
      #!/bin/bash
      exec "#{libexec}/scan-build" "$@"
    EOS
    (bin+'scan-view').write <<-EOS.undent
      #!/bin/bash
      exec "#{libexec}/scan-view" "$@"
    EOS
  end

  def test
    mktemp do
      (Pathname.pwd+'scan-build-test.c').write <<-EOS.undent
        int main(int argc, char **argv)
        {
            return 0;
        }
      EOS
      (Pathname.pwd+'Makefile').write <<-EOS.undent
        CC=/bin/false
        all:
        \t$(CC) scan-build-test.c
      EOS
      # need "make -e" to force "CC" set by scan-build to override the makefile
      # macro
      system "scan-build", "make", "-e"
    end
  end
end
