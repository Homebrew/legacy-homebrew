require 'formula'

class CsvSplit < Formula
  homepage 'https://github.com/PerformanceHorizonGroup/csv-split'
  url 'https://github.com/PerformanceHorizonGroup/csv-split/archive/0.1.1.tar.gz'
  version '0.1.1'
  sha1 'e586ffb24480ee001a402c9c7dee93786c8ee2e9'

  def install
    system 'make'
    system 'make install'
  end
end