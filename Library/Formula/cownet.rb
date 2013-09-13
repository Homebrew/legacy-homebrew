require 'formula'

class Cownet < Formula
  homepage 'http://obihann.github.io/Cownet/'
  url 'https://github.com/obihann/Cownet/archive/0.2.0-beta.tar.gz'
  version '0.2.0'
  sha1 '16a7b8e563d086a1b5078ce15f7f8688e2a59572'

  depends_on :python
  depends_on "figlet"
  depends_on "cowsay"

  def install
    system python, "setup.py", "install", "--home=#{prefix}"
  end
end