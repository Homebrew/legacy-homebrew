require 'formula'

class Tlassemble < Formula
  homepage 'http://www.dayofthenewdan.com/projects/tlassemble/'
  url 'https://github.com/dbridges/cocoa-tlassemble/archive/v1.0.zip'
  sha1 'afb9e809051de7022ee9e7b8649b2ef3abab70d7'
  version '1.0'

  def install
    system 'make'
    bin.install 'tlassemble'
  end

  test do
    system "tlassemble --help | grep 'tlassemble 1.0'"
  end
end
