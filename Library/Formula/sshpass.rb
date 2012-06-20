require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Sshpass < Formula
  homepage 'http://sourceforge.net/projects/sshpass/'
  url 'http://downloads.sourceforge.net/project/sshpass/sshpass/1.05/sshpass-1.05.tar.gz'
  sha1 '6dafec86dd74315913417829542f4023545c8fd7'

  def install
    # ENV.x11 # if your formula requires any X11 headers
    # ENV.j1  # if your formula's build system can't parallelize

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    system "bin/sshpass"
  end
end
