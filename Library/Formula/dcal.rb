require 'formula'

class Dcal < Formula
  url 'http://alexeyt.freeshell.org/code/dcal.c'
  homepage 'http://alexeyt.freeshell.org/'
  sha1 '3b1d4ed45ed0192df4841ed9e371c89fe87bdeac'
  version '0.1.0'

  def install
    system ENV.cxx, "dcal.c", "-o", "dcal"
    bin.install 'dcal'
  end
end
