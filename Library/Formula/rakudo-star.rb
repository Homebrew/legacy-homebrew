require "formula"

class RakudoStar < Formula
  homepage "http://rakudo.org/"
  url "http://rakudo.org/downloads/star/rakudo-star-2015.02.tar.gz"
  sha256 "e54309b0d79afc1491767110ec39a1aa7d9314d93e29dbaab082014cfb055611"

  bottle do
    sha1 "317094904815718655392b889726bea877c1be4b" => :yosemite
    sha1 "16287a574e0281a0469083226c377ccbfd4ef7ee" => :mavericks
    sha1 "61f4e27a76d371d8c7721f0d7a70df02fe4e97d8" => :mountain_lion
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
