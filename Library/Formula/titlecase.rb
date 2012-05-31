require 'formula'

class Titlecase < Formula
  head 'https://github.com/ap/titlecase.git'
  homepage 'http://plasmasturm.org/code/titlecase/'

  def install
    bin.install "titlecase"
  end
end
