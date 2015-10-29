class Speex < Formula
  desc "Audio codec designed for speech"
  homepage "http://speex.org"
  url "http://downloads.us.xiph.org/releases/speex/speex-1.2rc1.tar.gz"
  sha256 "342f30dc57bd4a6dad41398365baaa690429660b10d866b7d508e8f1179cb7a6"

  bottle do
    cellar :any
    revision 2
    sha256 "fc685c1693b9a669112c9c13bf9b1758a6ac2adf45ff99fdbf8c6202254110bf" => :el_capitan
    sha1 "035c405657c5debb5e41d291bb44f508797a7b51" => :yosemite
    sha1 "123e086d2548614ff66691f46e6f6e3dce3fa362" => :mavericks
    sha1 "d9cb07f7de4d226c25d0b8ddbddd3fb0de5f5c53" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "libogg" => :recommended

  def install
    ENV.j1
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
