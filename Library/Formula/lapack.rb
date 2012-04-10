require 'formula'

class Lapack < Formula
  homepage 'http://www.netlib.org/lapack/'
  url 'http://www.netlib.org/lapack/lapack-3.4.0.tgz'
  md5 '02d5706ec03ba885fc246e5fa10d8c70'

  def install
    ENV.fortran

    # Copy over make.inc, to load in configuration for this platform
    mv "INSTALL/make.inc.gfortran", "make.inc"
    system "make", "PREFIX=#{prefix}", "install"
  end

  def test
    system "false"
  end
end
