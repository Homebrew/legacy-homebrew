require 'formula'

class Konoha < Formula
  homepage 'http://www.konohascript.org/'
  url 'https://github.com/konoha-project/konoha3/archive/v0.1.tar.gz'
  sha1 '85ee3527c9a2db2874280e506c09aab8809a6ad5'

  head 'https://github.com/konoha-project/konoha3.git'

  option 'tests', 'Verify the build with make test (1 min)'

  depends_on 'cmake' => :build
  depends_on :mpi => [:cc, :cxx]
  depends_on 'pcre'
  depends_on 'json-c'
  depends_on 'sqlite'
  depends_on 'mecab' if MacOS.version >= :mountain_lion
  depends_on :python # for python glue code

  def install
    args = std_cmake_args + ['..']
    mkdir 'build' do
      system 'cmake', *args
      system 'make'
      system 'make', 'test' if build.include? 'tests'
      system 'make', 'install'
    end
  end
end
