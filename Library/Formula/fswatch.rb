require 'formula'

class Fswatch < Formula
  homepage 'https://github.com/alandipert/fswatch'
  url 'https://github.com/alandipert/fswatch/archive/v1.3.2.tar.gz'
  sha1 'af52fd305b80bc5e05217edb1d8cdce02fdb4e91'

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system './autogen.sh'
    system './configure'
    system 'make'
    bin.install 'fswatch'
  end

  test do
    system "fswatch 2>&1| grep 'You must specify a directory to watch'"
  end
end
