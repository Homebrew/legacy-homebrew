require 'formula'

class Flip <Formula
  url 'https://ccrma.stanford.edu/~craig/utility/flip/flip.cpp'
  homepage 'https://ccrma.stanford.edu/~craig/utility/flip/'
  md5 '21dc9256584eceffcfc27e137b3f8bc5'
  version '2005.8.21' # It has no version number, I made one up from the last modified date

  def install
    system "#{ENV.cxx} #{ENV['CXXFLAGS']} -o flip flip.cpp && strip flip"
    bin.install "flip"
  end
end
