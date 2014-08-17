require 'formula'

class Cloc < Formula
  homepage 'http://cloc.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/cloc/cloc/v1.62/cloc-1.62.pl'
  sha1 '78f6123c967f9b142f77cba48decd11d56ab6c38'

  def install
    bin.install "cloc-#{version}.pl" => "cloc"
  end
end
