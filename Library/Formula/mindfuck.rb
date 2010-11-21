require 'formula'

class Mindfuck <Formula
  url 'https://github.com/garretraziel/mindfuck/tarball/master'
  homepage 'https://github.com/garretraziel/mindfuck'
  version '0.1'
  md5 'f3876f8af35af88a4a61a1eab57bc528'

  def install
    system "cp mindfuck.py mindfuck"
    system "chmod +x mindfuck"
    bin.install "mindfuck"
    bin.install "pyfuk.py"
    bin.install "pyfuk.pyc"
  end
end
