class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "http://www.abisource.com/projects/link-grammar/"
  url "http://www.abisource.com/downloads/link-grammar/5.3.2/link-grammar-5.3.2.tar.gz"
  sha256 "59c6a2e5aca78ced741709317e1858ea57f2cefcece277daa8197c5247dec11d"

  bottle do
    sha256 "4104f550c5765f474e9fe430f50d6bd150d13fa0f74a2e34053d8e8d1791769d" => :mavericks
    sha256 "00f5f21c2e169d9bd7dea49cd5cab32ea3804958935f3632d8edc60e4a2ed536" => :mountain_lion
    sha256 "b4121c9596d3c6d2e46b2eab6f65f29c588fd37da2f0b9a7a79d005217928282" => :lion
  end

  # Can be removed with the next release
  # Bug fix in the test_enabled macro
  # https://github.com/opencog/link-grammar/issues/255
  patch do
    url "https://github.com/opencog/link-grammar/commit/61a788512b78b12b94429f8863ca6c3ee6eafe05.patch"
    sha256 "8da30ed3a86120101b8f5253af4bf42e23b5da2a9f2f0336fd9e8761c1d37399"
  end

  # Can be removed with the next release
  # Disable Perl bindings by default
  # https://github.com/opencog/link-grammar/issues/255
  patch do
    url "https://github.com/ampli/link-grammar/commit/adabf00ddb05b32c98b34da6691f0638781b0994.patch"
    sha256 "6d9ec0de8349ab694035d75e3a3afefe7c031661b447eda1c0e673d4d0e1e2a4"
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on :ant => :build

  def install
    inreplace "autogen.sh", "libtoolize", "glibtoolize"
    system "./autogen.sh", "--no-configure"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/link-parser", "--version"
  end
end
