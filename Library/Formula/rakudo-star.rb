class RakudoStar < Formula
  desc "Perl 6 compiler"
  homepage "http://rakudo.org/"
  url "http://rakudo.org/downloads/star/rakudo-star-2015.11.tar.gz"
  sha256 "714aed706706f02efeadc0d7e4c7ad216de5ded80d4a1b2879c275d5d05beae7"

  bottle do
    sha256 "1dc08a7a33242131b827e7e266b8af9d3fb630dba738f9c22250de77a7088eb1" => :el_capitan
    sha256 "422c27c197fe44d47ac5df2295f88370937812b13257160953712fe96258f609" => :yosemite
    sha256 "4fb89edadbc6d8db1bf752d7d3e9e9ccee5cfe78d89668d73ea0411eba50a88b" => :mavericks
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
