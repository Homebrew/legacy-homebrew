require 'formula'

class Igloo < Formula
  homepage 'http://igloo-testing.org'
  url 'https://github.com/joakimkarlsson/igloo/archive/igloo.1.0.0.tar.gz'
  sha1 'f6b538862e4b83e1a389b27fd79f1b89ff1f3c76'
  option 'skip-tests', 'Skip performing a self test on build'
  depends_on 'cmake' => :build unless build.include? 'skip-tests'

  def install
    unless build.include? 'skip-tests'
      system "cmake", ".", *std_cmake_args
      system "make"
      system "bin/igloo-tests"
    end
    include.install "igloo"
  end
end
