require "formula"

class RakudoStar < Formula
  homepage "http://rakudo.org/"
  url "http://rakudo.org/downloads/star/rakudo-star-2014.04.tar.gz"
  sha256 "f4fc1e3193db0fa876978527011034a711fdf20a87ee10edbb2dc62958cfed6a"

  bottle do
    sha1 "b6bb0365b0abed0186c46a6e5f4798ca0003f93a" => :mavericks
    sha1 "ae1149342867020918fb46348a7d89b4d59f686b" => :mountain_lion
    sha1 "5027d72cf160d00bae59ea35c98cf0aadd4ae102" => :lion
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
    if build.with? "jvm"
      system "perl", "Configure.pl", "--prefix=#{prefix}", "--backends=parrot,jvm", "--gen-parrot"
    else
      system "perl", "Configure.pl", "--prefix=#{prefix}", "--backends=parrot", "--gen-parrot"
    end
    system "make"
    system "make install"
    # move the man pages out of the top level into share.
    mv "#{prefix}/man", share
  end

  test do
    out = `#{bin}/perl6 -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'`
    assert_equal "0123456789", out
    assert_equal 0, $?.exitstatus
  end
end
