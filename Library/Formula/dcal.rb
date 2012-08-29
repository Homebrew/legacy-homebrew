require 'formula'

class Dcal < Formula
  url 'http://alexeyt.freeshell.org/code/dcal.c'
  homepage 'http://alexeyt.freeshell.org/'
  md5 '66e6abfccf934cf1e7fb8e467cc8f005'
  version '0.1.0'

  def install
    system ENV.cxx, "dcal.c", "-o", "dcal"
    bin.install 'dcal'
  end
end
