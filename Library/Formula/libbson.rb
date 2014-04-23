require 'formula'

class Libbson < Formula
  homepage 'https://github.com/mongodb/libbson'
  url 'https://github.com/mongodb/libbson/releases/download/0.6.8/libbson-0.6.8.tar.gz'
  sha1 '96f7bb4bcc6a5b1e40e1c9179d96212f8846c1dc'

  depends_on :automake

  def install
    system "./configure", "--enable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end
