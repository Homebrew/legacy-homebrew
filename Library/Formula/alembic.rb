require 'formula'

class Alembic < Formula
  homepage 'http://opensource.imageworks.com/?p=alembic'
  url 'http://alembic.googlecode.com/files/Alembic_1.1.5_2013041100.tgz'
  sha1 '539813017342d156ed5b0efafc983bda9b2cb001'
  version '1.1.5'

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'hdf5'
  depends_on 'ilmbase'

  def install
    cmake_args = std_cmake_args + %w{. -DUSE_PYILMBASE=OFF -DUSE_PRMAN=OFF -DUSE_ARNOLD=OFF -DUSE_MAYA=OFF -DUSE_PYALEMBIC=OFF}
    system "cmake", *cmake_args
    system "make", "install"
    #move everything upwards
    lib.install_symlink Dir[prefix/"alembic-#{version}/lib/static/*"]
    include.install_symlink Dir[prefix/"alembic-#{version}/include/*"]
    bin.install_symlink Dir[prefix/"alembic-#{version}/bin/*"]
  end
end
