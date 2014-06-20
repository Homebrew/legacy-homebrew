require 'formula'

class Mupdf < Formula
  homepage 'http://mupdf.com'
  url 'http://mupdf.com/downloads/mupdf-1.5-source.tar.gz'
  sha1 '628470ed20f9a03c81e90cd5585a31c0fab386ef'

  bottle do
    cellar :any
    sha1 "c4e3b26fc0969b29930ee2eb8a76a9eac183f4cc" => :mavericks
    sha1 "69c2fabdf1c244a978db82927c5f0f68d71783c0" => :mountain_lion
    sha1 "283487c7f77029e1b6801142a091a19e933964d6" => :lion
  end

  depends_on :macos => :snow_leopard
  depends_on :x11

  def install
    system "make", "install", "build=release", "prefix=#{prefix}"
  end
end
