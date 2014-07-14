require 'formula'

class Arpoison < Formula
  homepage 'http://www.arpoison.net/'
  url 'http://www.arpoison.net/arpoison-0.7.tar.gz'
  sha1 '14e89b1acbd09874fd389b3cef0dd1a7c7f253ae'

  bottle do
    cellar :any
    sha1 "e350e47d43c370aa48cb2bfb944cff1723ab500d" => :mavericks
    sha1 "3fbfa7b1e1a21d1bdd8c61b2aefb84aca7dc91f6" => :mountain_lion
    sha1 "465efcfc1778734810c249a71892d062eaf41b45" => :lion
  end

  depends_on 'libnet'

  def install
    system "make"
    bin.install "arpoison"
  end
end
