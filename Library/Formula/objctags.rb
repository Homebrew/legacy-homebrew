require 'formula'

class Objctags < Formula
  homepage 'https://github.com/lembacon/objctags'
  url 'https://github.com/lembacon/objctags/archive/v0.0.2.tar.gz'
  sha1 'b769dba46166919061f66fd68b84d8971e820549'

  head 'https://github.com/lembacon/objctags.git', :branch => 'master'

  depends_on 'cmake' => :build
  depends_on 'llvm' => %w[with-clang disable-assertions]

  def install
    inreplace 'CMakeLists.txt',
              'set(LLVM_PREFIX /usr/local)',
              "set(LLVM_PREFIX #{HOMEBREW_PREFIX})"

    cd 'build' do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end
end
