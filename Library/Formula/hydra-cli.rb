require "formula"

class HydraCli < Formula
  homepage 'https://github.com/sdegutis/hydra-cli'
  url 'https://github.com/sdegutis/hydra-cli/archive/1.0.tar.gz'
  sha1 '15906ca4255839844635f26eab83843f0426b5f9'
  head 'https://github.com/sdegutis/hydra-cli.git'

  bottle do
    cellar :any
    sha1 "5b23c9395fb73f77463922c2021350bbca8dd2e1" => :mavericks
    sha1 "7f645a2a45f2b9cb578e8c117281708b3cfdf83f" => :mountain_lion
    sha1 "0153b1fce7c2ea3e1726320d53fe2fccea574ef4" => :lion
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/hydra", "-h"
  end
end
