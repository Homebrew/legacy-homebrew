class RakudoStar < Formula
  desc "Perl 6 compiler"
  homepage "http://rakudo.org/"
  url "http://rakudo.org/downloads/star/rakudo-star-2016.01.tar.gz"
  sha256 "feb385c5d05166061f413882e442d3a0ec53884918768940d3f00bb63bc85497"

  bottle do
    revision 1
    sha256 "ad1afb2118e92cdb8346a44d79bce84402a97f1684200e196d60f992c77ef761" => :el_capitan
    sha256 "ef13d148a2c29823396c802df05d5660599e625bbe8986459a1e0831ff31922e" => :yosemite
    sha256 "5859e7ac8ea70001bedd2eb636084fac81a37a208c067661a4fdd003aa9e3759" => :mavericks
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
