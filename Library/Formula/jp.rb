require 'formula'

class Jp < Formula
  homepage 'http://www.paulhammond.org/jp/'
  url 'https://github.com/paulhammond/jp/archive/v0.1.tar.gz'
  sha1 'c4cc3f484d06154c8a6e5402e8ce5e0b570a2b33'

  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = pwd
    mkdir_p 'src'
    mv 'jp', 'src/jp'
    system 'go get jp'
    bin.install 'bin/jp'
  end

  test do
    json = '{"foo":[1,2],"home":"brew"}'
    File.open('data.json', 'w') { |f| f.write json }
    `jp data.json`.gsub(/\s+/, '') == json
  end
end
