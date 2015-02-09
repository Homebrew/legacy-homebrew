require "formula"

class RakudoStar < Formula
  homepage "http://rakudo.org/"
  url "http://rakudo.org/downloads/star/rakudo-star-2015.01.tar.gz"
  sha256 "30c22e729bb6290e120bf7eb9b28a691090183b010a7f91aefd4d25a2c2d12bf"

  bottle do
    sha1 "3475077e3a06cd6602228bfddd86617f9a565d80" => :yosemite
    sha1 "3a58076b45388fbbcf5598eb46c6acd516eabec3" => :mavericks
    sha1 "c6135cdccafeefc44ae73406bf9909c071c5b12d" => :mountain_lion
  end

  option "with-jvm", "Build also for jvm as an alternate backend."
  option "with-parrot", "Build also for parrot as an alternate backend."

  conflicts_with "parrot"

  depends_on "gmp" => :optional
  depends_on "icu4c" => :optional
  depends_on "pcre" => :optional
  depends_on "libffi"

  def install
    libffi = Formula["libffi"]
    ENV.remove "CPPFLAGS", "-I#{libffi.include}"
    ENV.prepend "CPPFLAGS", "-I#{libffi.lib}/libffi-#{libffi.version}/include"

    ENV.j1  # An intermittent race condition causes random build failures.

    backends = ["moar"]
    generate = ["--gen-moar"]

    if build.with? "jvm"
      backends << "jvm"
    end
    if build.with? "parrot"
      backends << "parrot"
      generate << "--gen-parrot"
    end
    system "perl", "Configure.pl", "--prefix=#{prefix}", "--backends=" + backends.join(","), *generate
    system "make"
    system "make install"

    # Move the man pages out of the top level into share.
    # Not all backends seem to generate man pages at this point (moar does not, parrot does),
    # so we need to check if the directory exists first.
    if File.directory?("#{prefix}/man")
      mv "#{prefix}/man", share
    end
  end

  test do
    out = `#{bin}/perl6 -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'`
    assert_equal "0123456789", out
    assert_equal 0, $?.exitstatus
  end
end
