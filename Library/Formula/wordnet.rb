class Wordnet < Formula
  desc "Lexical database for the English language"
  homepage "https://wordnet.princeton.edu/"
  url "http://wordnetcode.princeton.edu/3.0/WordNet-3.0.tar.bz2"
  # Version 3.1 is version 3.0 with the 3.1 dictionary.
  version "3.1"
  sha256 "6c492d0c7b4a40e7674d088191d3aa11f373bb1da60762e098b8ee2dda96ef22"

  bottle do
    sha256 "412b4cc4b65d5083176aa69647ab5a15b96b63b758fa8900c80b402c5a9d2cb6" => :el_capitan
    sha256 "876de343c8e2d508af818a7aacdcc8015f7e662edf8f08e068ca7800f48d50d4" => :yosemite
    sha256 "786bc9b811d958b71888cc87e0ef75a6cd66ebc05202278b7827f847f6b4dfe5" => :mavericks
  end

  depends_on :x11

  resource "dict" do
    url "http://wordnetcode.princeton.edu/wn3.1.dict.tar.gz"
    sha256 "3f7d8be8ef6ecc7167d39b10d66954ec734280b5bdcd57f7d9eafe429d11c22a"
    version "3.1"
  end

  def install
    (prefix/"dict").install resource("dict")

    # Disable calling deprecated fields within the Tcl_Interp during compilation.
    # https://bugzilla.redhat.com/show_bug.cgi?id=902561
    ENV.append_to_cflags "-DUSE_INTERP_RESULT"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-tcl=#{MacOS.sdk_path}/usr/lib",
                          "--with-tk=#{MacOS.sdk_path}/usr/lib"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/wn homebrew -synsn")
    assert_match /alcoholic beverage/, output
  end
end
