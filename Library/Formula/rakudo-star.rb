class RakudoStar < Formula
  desc "Perl 6 compiler"
  homepage "http://rakudo.org/"
  url "https://github.com/rakudo/rakudo/archive/2015.12.tar.gz"
  sha256 "d7c4fd1c8bc525e16cefe2d28513dcd9642ecbed37775cd2a89b324a62278780"

  bottle do
    sha256 "7de961893c649707a3d0ddb943909fd9be4e0ac6d8859c327b00807c654068f7" => :el_capitan
    sha256 "d1af4fbaa08cd8869ec30088dcf3c2b535681e71ad26575e867f6e0a7c6e8898" => :yosemite
    sha256 "f9220ee6259bdc542be0a2f540ca2d9049520a2cc488f5a966c17af91cbd529b" => :mavericks
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

    ENV.j1 # An intermittent race condition causes random build failures.

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
