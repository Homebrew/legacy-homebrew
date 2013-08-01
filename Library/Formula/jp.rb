require 'formula'

class Jp < Formula
  homepage 'http://www.paulhammond.org/jp/'
  url 'https://github.com/paulhammond/jp/archive/v0.1.tar.gz'
  sha1 'c4cc3f484d06154c8a6e5402e8ce5e0b570a2b33'

  depends_on "go" => :build

  def install
    system "/bin/mkdir -p #{buildpath}/build/src/github.com/paulhammond"
    system "/bin/ln -s #{buildpath} #{buildpath}/build/src/github.com/paulhammond/jp"
    ENV["GOPATH"] = "#{buildpath}/build"
    system "go install github.com/paulhammond/jp/jp"
    bin.install('build/bin/jp')
  end

  test do
    `echo '{"foo": "bar" }' | jp -compact - ` == '{"foo":"bar"}'
  end
end
