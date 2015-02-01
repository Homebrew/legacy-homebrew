require "formula"

class RakudoStar < Formula
  homepage "http://rakudo.org/"
  url "http://rakudo.org/downloads/star/rakudo-star-2014.12.2.tar.gz"
  sha256 "55d47b0e36c9c21036fc0de8d195ef39e3fd589b1d88d9959932d0cc104d92a1"

  bottle do
    revision 1
    sha1 "0cecf848006c3efb275c2d1fd005e948f5d74650" => :yosemite
    sha1 "163f336f077e10bacbe6ab08da520336d0636d78" => :mavericks
    sha1 "0387a42e9bfdd816312ff1b377391dbebc6e3185" => :mountain_lion
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
