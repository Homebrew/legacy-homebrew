require 'formula'

class Prodigal < Formula
  homepage 'http://prodigal.ornl.gov/'
  url 'http://prodigal.googlecode.com/files/prodigal.v2_60.tar.gz'
  sha1 '23a45dafedd98c04f9a4edbe82b037120644eaa2'

  def install
    system "make"
    bin.install 'prodigal'
  end
end
