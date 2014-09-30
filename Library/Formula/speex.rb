require 'formula'

class Speex < Formula
  homepage 'http://speex.org'
  url 'http://downloads.us.xiph.org/releases/speex/speex-1.2rc1.tar.gz'
  sha1 '52daa72572e844e5165315e208da539b2a55c5eb'

  bottle do
    cellar :any
    revision 1
    sha1 "fa844de615cebcbc56ce840dd445d1c20b2c25fa" => :mavericks
    sha1 "3de84ed43a3945ee00195decddba1beaeacfec4b" => :mountain_lion
    sha1 "6f9ccd4aede4209d2b6ffe78b27fe341d0f36f31" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libogg' => :recommended

  def install
    ENV.j1
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
