class Cc65 < Formula
  desc "6502 C compiler"
  homepage "https://cc65.github.io/cc65/"
  url "ftp://ftp.musoftware.de/pub/uz/cc65/cc65-sources-2.13.3.tar.bz2"
  sha256 "a98a1b69d3fa15551fe7d53d5bebfc5f9b2aafb9642ee14b735587a421e00468"

  # CC65 stable has ceased to be maintained as of March 2013.
  # The head build has a new home, and new maintainer, but no new stable release yet.
  head "https://github.com/cc65/cc65.git"

  bottle do
    sha256 "a8d0601368f3f6c4048c63e4f785d5159c0aab3f4e3a86c49a65cd3cdf69ae53" => :el_capitan
    sha256 "0320f31da62970bce189a3d6b8bdae5e595fa113eba7a37b5812e75dc6f89d72" => :yosemite
    sha256 "8f56a19db5bfa9d606e7f636c3780a7e29206e0f9b845365f91550f58e46d2b4" => :mavericks
  end

  conflicts_with "grc", :because => "both install `grc` binaries"

  def install
    ENV.deparallelize
    ENV.no_optimization

    make_vars = ["prefix=#{prefix}", "libdir=#{share}"]

    if head?
      system "make", *make_vars
      system "make", "install", *make_vars
    else
      system "make", "-f", "make/gcc.mak", *make_vars
      system "make", "-f", "make/gcc.mak", "install", *make_vars
    end
  end

  def caveats; <<-EOS.undent
    Library files have been installed to:
      #{pkgshare}
    EOS
  end

  test do
    (testpath/"foo.c").write "int main (void) { return 0; }"

    system bin/"cl65", "foo.c" # compile and link
    assert File.exist?("foo")  # binary
  end
end
