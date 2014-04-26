require 'formula'

class RakudoStar < Formula
  homepage 'http://rakudo.org/'
  url 'http://rakudo.org/downloads/star/rakudo-star-2014.03.tar.gz'
  sha256 '6b285fb3fbbfa22f5986a2890cd0ca29de8efb3a60b2d60e948140c24320a994'

  bottle do
    sha1 "8713766c33d97f16eba1764e3a89137d58fa4ee3" => :mavericks
    sha1 "cd24cf9b2b76949f3bba68f404ee8574da524639" => :mountain_lion
    sha1 "ad7b50e1e85f2552f89f1e5fbdf2741659b8763b" => :lion
  end

  option 'with-jvm', 'Build also for jvm as an alternate backend.'

  conflicts_with 'parrot'

  depends_on 'gmp' => :optional
  depends_on 'icu4c' => :optional
  depends_on 'pcre' => :optional
  depends_on 'libffi'

  def install
    libffi = Formula["libffi"]
    ENV.remove 'CPPFLAGS', "-I#{libffi.include}"
    ENV.prepend 'CPPFLAGS', "-I#{libffi.lib}/libffi-#{libffi.version}/include"

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
