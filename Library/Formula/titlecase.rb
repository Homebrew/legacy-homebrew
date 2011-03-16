require 'formula'

class Titlecase < Formula
  head 'git://github.com/ap/titlecase.git'
  homepage 'http://plasmasturm.org/code/titlecase/'

  def install
    bin.install "titlecase"
  end
end
