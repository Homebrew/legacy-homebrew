class RakudoStar < Formula
  desc "Perl 6 compiler"
  homepage "http://rakudo.org/"
  url "http://rakudo.org/downloads/star/rakudo-star-2015.07.tar.gz"
  sha256 "84d7812a735eedc39d7c0898d4fd15ecd82563971744b2bc6ff0a1c581c82910"

  bottle do
    sha256 "a9062bc75fdc50d09522957ed32fca13426f03ffbce38d70bdce696b5a0e595d" => :el_capitan
    sha256 "82e75716f260d56213902d41ea0c3f4f31c9c38202cc605887eba97c1fd9c762" => :yosemite
    sha256 "5ef37f2b8a655614ae64c488ec29bc758e336df52216405a47eda09283e261d2" => :mavericks
    sha256 "21eeb7930847526b283fe411c0e9c733fd915f31ff66127985a0b4aebb9c80a0" => :mountain_lion
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

    backends << "jvm" if build.with? "jvm"

    system "perl", "Configure.pl", "--prefix=#{prefix}", "--backends=" + backends.join(","), *generate
    system "make"
    system "make", "install"

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
