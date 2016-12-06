require 'formula'
require 'requirement'

class Emacs24Requirement < Requirement
  fatal true

  satisfy do
    system 'emacs --batch --eval="(require \'package)"'
  end

  def message
    'Please install a version of Emacs >= 24.'
  end
end

class Carton < Formula
  homepage 'https://github.com/rejeep/carton#readme'
  url 'https://github.com/rejeep/carton/archive/v0.3.1.tar.gz'
  sha1 'd8c76e6db32d319f95bfec1abad4627c144dd9df'
  head 'https://github.com/rejeep/carton.git'

  depends_on Emacs24Requirement unless build.head?
  # Carton has started to provide a version of `package` for users of Emacs 23.

  def install
    prefix.install %w{carton.el templates/}
    bin.install 'bin/carton'
    prefix.install 'carton-package.el' if build.head?
  end

  test do
    system 'carton', 'help'
  end
end
