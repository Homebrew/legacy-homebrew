require 'formula'

class Carton < Formula
  homepage 'https://github.com/rejeep/carton#readme'
  url 'https://github.com/rejeep/carton/archive/v0.3.1.tar.gz'
  sha1 'd8c76e6db32d319f95bfec1abad4627c144dd9df'
  head 'https://github.com/rejeep/carton.git'

  # `package.el` is only included by default in Emacs >= 24
  depends_on 'emacs'

  def install
    prefix.install Dir['*']
  end

  test do
    system 'carton', 'help'
  end
end
