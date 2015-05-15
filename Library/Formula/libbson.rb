require "formula"

class Libbson < Formula
  homepage "https://github.com/mongodb/libbson"
  url "https://github.com/mongodb/libbson/releases/download/1.1.5/libbson-1.1.5.tar.gz"
  sha1 "dd550ba4b6b15300e0a49ac9d1d393d9dc42ee82"

  bottle do
    cellar :any
    sha256 "ed19e2a59a1118b16eeb981126366258b8cbd711d967d2203d2ed889f7372143" => :yosemite
    sha256 "f9a360d5bed6d2022b13c04fa4115be8f5995c4873ac0e84f63af879a0f79a4d" => :mavericks
    sha256 "4cc19edf4c79f623e07d6fffe082598c127bdeec0be4f9d91ee05d8aeb315942" => :mountain_lion
  end

  def install
    system "./configure", "--enable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end
