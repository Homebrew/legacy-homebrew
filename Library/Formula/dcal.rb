require 'formula'

class Dcal < Formula
  homepage 'http://alexeyt.freeshell.org/'
  url 'http://alexeyt.freeshell.org/code/dcal.c'
  version '0.1.0'
  sha1 '3b1d4ed45ed0192df4841ed9e371c89fe87bdeac'

  def install
    system ENV.cxx, "dcal.c", "-o", "dcal"
    bin.install 'dcal'
  end
end
