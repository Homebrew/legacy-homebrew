require 'formula'

class IncludeWhatYouUse < Formula
  CLANG_VERSION = '3.5'

  homepage 'https://code.google.com/p/include-what-you-use/'
  url "http://include-what-you-use.googlecode.com/svn/branches/clang_#{IncludeWhatYouUse::CLANG_VERSION}",
      revision: '582'
  version '0.3'
  sha1 'f49dd094300b648543e3510ebd8101dbab23056f'

  depends_on 'cmake' => :build
  depends_on 'llvm' => [:build, 'with-clang']

  def install
    system 'cmake', "-DLLVM_PATH=#{HOMEBREW_PREFIX}/llvm/#{IncludeWhatYouUse::CLANG_VERSION}/",
           buildpath, "-DCMAKE_INSTALL_PREFIX=#{prefix}/", *std_cmake_args
    system 'make', 'install'
    bin.install 'fix_includes.py'
  end

  test do
    # write out a header and a C file relying on transitive dependencies
    (testpath/'demo.h').write('#include <stdio.h>')
    (testpath/'demo.c').write <<-EOS.undent
    #include "demo.h"

    int main(void)
    { printf("hello world"); }
    EOS

    # iwyu always exits with status 1 so assert that and capture output
    fixes = shell_output "include-what-you-use #{testpath}/demo.c 2>&1", 1

    # pass the output to the fixer script and assert that it fixed one file
    results = pipe_output 'fix_includes.py', fixes

    # sigh. they use the status code to signal how many files were edited
    assert_equal 1, $?.exitstatus
  end
end
