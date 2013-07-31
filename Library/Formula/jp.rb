require 'formula'

class Jp < Formula
  homepage 'http://www.paulhammond.org/jp/'
  url 'http://www.paulhammond.org/jp/jp-0.1-mac.tgz'
  sha1 '5495c61cbe250ea0e56ba795f37e5d04a506609a'

  def install
    bin.install 'jp'
  end

  test do
    json = '{"foo":[1,2],"home":"brew"}'
    File.open('data.json', 'w') { |f| f.write json }
    `jp data.json`.gsub(/\s+/, '') == json
  end
end
