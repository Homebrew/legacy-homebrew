require 'formula'

class Etcdctl < Formula
  homepage 'https://github.com/coreos/etcdctl'
  url 'https://github.com/coreos/etcdctl/archive/v0.4.4.tar.gz'
  sha1 '44c88abdd40ff53fd8bb64f41936806b854936fe'
  head 'https://github.com/coreos/etcdctl.git'

  bottle do
    sha1 "ee0471621da897916e0129edc72a3e427fe3a5c8" => :mavericks
    sha1 "5d3098326902645ac8d6338224b66e3451c1321c" => :mountain_lion
    sha1 "b3191d68fb77a1f6930d4e35ea0d83f7bf87423e" => :lion
  end

  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath
    system "./build"
    bin.install 'bin/etcdctl'
  end
end
