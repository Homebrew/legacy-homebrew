require 'formula'

class Openmeta < Formula
  homepage 'https://code.google.com/p/openmeta/'
  url      'https://openmeta.googlecode.com/files/openmeta_commandline_1.3.0.zip'
  sha1     '6318f747608be7836cb4366ae18fb2c237504ec6'

  def install
    bin.install "openmeta"
  end
end
