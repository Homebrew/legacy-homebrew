require "formula"

class RakudoStar < Formula
  homepage "http://rakudo.org/"
  url "http://rakudo.org/downloads/star/rakudo-star-2014.09.tar.gz"
  sha256 "e7cfc6f4d92d9841f03246d68d51ed54d48df08736b0bd73626fe45196498649"
  revision 1

  bottle do
    sha1 "7e08ef6970f7ba7a0ca09a3f61af36b86f781190" => :mavericks
    sha1 "b88775df9edaa92a9a7454f644e7c8166a70ee80" => :mountain_lion
    sha1 "e7d57f6e3dd5eca35d7e6154da7791dc9e3da531" => :lion
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
