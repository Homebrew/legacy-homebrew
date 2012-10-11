require 'formula'

class Konoha < Formula
  homepage 'http://www.konohascript.org/'
  url 'http://konoha.googlecode.com/files/konoha-1.0.0-952.tar.gz'
  sha1 'c4cfdc956bd583f8c3e8e696eeb0316ca78b1389'

  depends_on 'cmake' => :build
  depends_on MPIDependency.new(:cc, :cxx)
  depends_on 'pcre'
  depends_on 'json-c'
  depends_on 'sqlite'

  def install
    args = std_cmake_args + ['..']
    cd 'build' do
      system 'cmake', *args
      system 'make'
      system 'make install'
    end
  end
end
