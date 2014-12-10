require 'formula'

class Zmap < Formula
  homepage 'https://zmap.io'
  url 'https://github.com/zmap/zmap/archive/v1.2.1.tar.gz'
  sha1 '1ce5529d8685a7b7fbca1f3b04670b1614838fa7'

  head 'https://github.com/zmap/zmap.git'

  bottle do
    cellar :any
    sha1 "67ee1c3239a4109088a7b5f9d9db4884640c1920" => :mavericks
    sha1 "3d780dc9a1125d96294d7071b1cdc359ccf4f302" => :mountain_lion
    sha1 "b0482d7fedc3063f7218997f4ecdcb93043f898a" => :lion
  end

  depends_on 'cmake' => :build
  depends_on 'gengetopt' => :build
  depends_on 'byacc' => :build
  depends_on 'gmp'
  depends_on 'libdnet'
  depends_on 'json-c' => :optional
  depends_on 'hiredis' => :optional

  def install
    inreplace ['conf/zmap.conf','src/zmap.c','src/zopt.ggo'], '/etc', etc

    args = std_cmake_args
    args << '-DRESPECT_INSTALL_PREFIX_CONFIG=ON'
    args << '-DWITH_JSON=ON' if build.with? 'json-c'
    args << '-DWITH_REDIS=ON' if build.with? 'hiredis'

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "#{sbin}/zmap", "--version"
    assert_match /json/, `#{sbin}/zmap --list-output-modules` if build.with? 'json-c'
    assert_match /redis/, `#{sbin}/zmap --list-output-modules` if build.with? 'hiredis'
  end
end
