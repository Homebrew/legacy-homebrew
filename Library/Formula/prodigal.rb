require 'formula'

class Prodigal < Formula
  url 'http://prodigal.googlecode.com/files/prodigal.v2_00.tar.gz'
  homepage 'http://prodigal.ornl.gov/'
  md5 'd110bd6a28004fc6ba4d13066b6103e2'

  def install
    system "make"
    bin.install 'prodigal'
  end
end
