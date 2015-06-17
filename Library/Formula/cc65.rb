require 'formula'

class Cc65 < Formula
  desc "6502 C compiler"
  homepage 'https://cc65.github.io/cc65/'
  # CC65 stable has ceased to be maintained as of March 2013.
  # The head build has a new home, and new maintainer, but no new stable release yet.
  head 'https://github.com/cc65/cc65.git'
  url 'ftp://ftp.musoftware.de/pub/uz/cc65/cc65-sources-2.13.3.tar.bz2'
  sha1 '925c6edfcef7057e24ecb0704fa07210faec07bc'

  conflicts_with 'grc', :because => 'both install `grc` binaries'

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
      #{share}/cc65
    EOS
  end

  test do
    (testpath/"foo.c").write "int main (void) { return 0; }"

    system bin/"cl65", "foo.c" # compile and link
    assert File.exist?("foo")  # binary
  end
end
