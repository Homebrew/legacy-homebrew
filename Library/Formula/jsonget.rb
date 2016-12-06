require 'formula'

class Jsonget < Formula
  homepage 'https://github.com/stvp/jsonget#readme'
  url 'https://s3.amazonaws.com/gofetch.us/darwin_amd64/github.com/stvp/jsonget/v0.0.2.tar.gz'
  sha1 '595851ceabea984e8f24aef82f327955972dd492'

  def install
    bin.install 'jsonget'
  end
end
