class Check < Formula
  desc "C unit testing framework"
  homepage "https://libcheck.github.io/check/"
  url "https://downloads.sourceforge.net/project/check/check/0.10.0/check-0.10.0.tar.gz"
  sha256 "f5f50766aa6f8fe5a2df752666ca01a950add45079aa06416b83765b1cf71052"

  bottle do
    cellar :any
    sha256 "2e37bca055ae0bf490b713d90c95a9d81518cae9b884a7e495f521c80b4f062f" => :el_capitan
    sha256 "bb824d8cb8a74ebbc1eb9d22b8ea15327dfe3ce91151b37c7f41c80939609f52" => :yosemite
    sha256 "022667ec28a8af0bf6e19f3afbaa144542f1754ebaff5710229484fa8071084e" => :mavericks
    sha256 "b223c76b5519c5aa3300488b230c5b5b2cbd32d896f2fab0f1a0700a24e1f975" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
