require 'formula'

class Cloc < Formula
  homepage 'http://cloc.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/cloc/cloc/v1.58/cloc-1.58.pl'
  sha1 'bf2b4478343da50d0eea83ad0ed3f126ff210d39'

  def install
    bin.install "cloc-#{version}.pl" => "cloc"
  end
end
