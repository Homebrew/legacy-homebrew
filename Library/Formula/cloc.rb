require 'formula'

class Cloc < Formula
  homepage 'http://cloc.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/cloc/cloc/v1.60/cloc-1.60.pl'
  sha1 'd002e85b7deb988e4f88eaf3f9697cf011ec0c8a'

  def install
    bin.install "cloc-#{version}.pl" => "cloc"
  end
end
