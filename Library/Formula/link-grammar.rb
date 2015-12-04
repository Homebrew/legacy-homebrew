class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "http://www.abisource.com/projects/link-grammar/"
  url "http://www.abisource.com/downloads/link-grammar/4.7.14/link-grammar-4.7.14.tar.gz"
  sha256 "6fe8b46c6f134c5c1e43fc0eaae048fe746c533a0cae8d63ad07fc2a3dff7667"

  bottle do
    sha256 "4104f550c5765f474e9fe430f50d6bd150d13fa0f74a2e34053d8e8d1791769d" => :mavericks
    sha256 "00f5f21c2e169d9bd7dea49cd5cab32ea3804958935f3632d8edc60e4a2ed536" => :mountain_lion
    sha256 "b4121c9596d3c6d2e46b2eab6f65f29c588fd37da2f0b9a7a79d005217928282" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on :ant => :build

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/link-parser", "--version"
  end
end
