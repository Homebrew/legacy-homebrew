require 'formula'

class Konoha < Formula
  homepage 'http://www.konohascript.org/'
  url 'https://github.com/downloads/konoha-project/minikonoha/minikonoha-0.1.0.tar.gz'
  sha1 '621aa1244c344a9e7be96fb6e6d067bae7f43d64'

  option 'tests', 'Verify the build with make test (1 min)'

  depends_on 'cmake' => :build
  depends_on MPIDependency.new(:cc, :cxx)
  depends_on 'pcre'
  depends_on 'json-c'
  depends_on 'sqlite'

  def install
    args = std_cmake_args + ['..']
    mkdir 'build' do
      system 'cmake', *args
      system 'make'
      system 'make test' if build.include? 'tests'
      system 'make install'
    end
  end
end
