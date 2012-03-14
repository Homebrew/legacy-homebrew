require 'formula'

class Flip < Formula
  homepage 'https://ccrma.stanford.edu/~craig/utility/flip/'
  url 'https://ccrma.stanford.edu/~craig/utility/flip/flip.cpp'
  version '2005.8.21' # It has no version number, I made one up from the last modified date
  md5 '21dc9256584eceffcfc27e137b3f8bc5'

  def install
    system "#{ENV.cxx} #{ENV['CXXFLAGS']} -o flip flip.cpp"
    bin.install "flip"
  end
end
