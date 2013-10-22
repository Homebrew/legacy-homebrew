require 'formula'

class Tlassemble < Formula
  homepage 'http://www.dayofthenewdan.com/projects/tlassemble/'
  url 'https://github.com/dbridges/cocoa-tlassemble/archive/v1.0.zip'
  sha1 'b19dd3cef88b1bb7483344e745f6bb317a17b59b'

  def install
    system 'make'
    bin.install 'tlassemble'
  end

  test do
    system "\"#{bin}/tlassemble\" --help | grep 'tlassemble 1.0'"
  end
end
