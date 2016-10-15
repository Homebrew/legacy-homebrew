require 'formula'

class Gitignorer < Formula
  homepage 'https://github.com/zachlatta/gitignorer'
  url 'https://github.com/zachlatta/gitignorer/archive/v1.0.0.tar.gz'
  sha1 'bb2726f86a7054cde3fc2713a3fecd8bd0334fed'

  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath

    directory = "github.com/zachlatta/gitignorer"
    system "mkdir -p src/#{ directory }"
    system "mv `ls -A | grep -v src` ./src/#{ directory }"
    system "cd src/#{ directory }; go get"

    system "cd src/#{ directory }; go install"
    bin.install 'bin/gitignorer'
  end

  test do
    system "#{bin}/gitignorer", "help"
  end
end
