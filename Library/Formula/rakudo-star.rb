require "formula"

class RakudoStar < Formula
  desc "Perl 6 compiler running on the Parrot VM"
  homepage "http://rakudo.org/"
  url "http://rakudo.org/downloads/star/rakudo-star-2015.03.tar.gz"
  sha256 "bb969c99b39cf69d0f04ae5e9d574de1da8835a1be17710f9e63afc0bcac9bbb"

  bottle do
    sha256 "d310af143caab23d561c00414a2b32f951236c43a00c788278e5f4abeaca8562" => :yosemite
    sha256 "d89c2ed4931ae97ee232a7dccf3a85e4517215ad4119e5c6bad0fb0334360d37" => :mavericks
    sha256 "7e26281eb2ad58e9be333151a2dde0bca7905d8193fe8c3061c2bcd92037caa5" => :mountain_lion
  end

  option "with-jvm", "Build also for jvm as an alternate backend."

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
