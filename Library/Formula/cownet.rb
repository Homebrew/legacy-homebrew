require 'formula'

class Cownet < Formula
  homepage 'http://obihann.github.io/Cownet/'
  url 'https://github.com/obihann/Cownet.git'
  version '0.2.0'
  sha1 '63beadee3d28baaba71c689454a051eb94fcdff6'
  depends_on :python
  depends_on "figlet"
  depends_on "cowsay"

  def install
      system python, "setup.py", "install", "--home=#{prefix}"
  end

  test do
      system 'false'
  end
end

