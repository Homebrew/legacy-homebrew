class Speex < Formula
  desc "Audio codec designed for speech"
  homepage "http://speex.org"
  url "http://downloads.us.xiph.org/releases/speex/speex-1.2rc1.tar.gz"
  sha256 "342f30dc57bd4a6dad41398365baaa690429660b10d866b7d508e8f1179cb7a6"

  bottle do
    cellar :any
    revision 2
    sha256 "fc685c1693b9a669112c9c13bf9b1758a6ac2adf45ff99fdbf8c6202254110bf" => :el_capitan
    sha256 "72bf08da8cf820cdf56072fa4bdb2cecf79d9eb8f4999873f48358f0acc92793" => :yosemite
    sha256 "79678ca5128b013bedd0e2dee757d4b746f3120b64742d6e9a587e91f2659b4a" => :mavericks
    sha256 "c245232af0587e05254cbce4d078f420c5bf79508c0021c2aa72edfdcdc4f8b2" => :mountain_lion
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
