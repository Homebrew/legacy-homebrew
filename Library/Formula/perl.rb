class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "http://www.cpan.org/src/5.0/perl-5.20.2.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/p/perl/perl_5.20.2.orig.tar.bz2"
  sha256 "e5a4713bc65e1da98ebd833dce425c000768bfe84d17ec5183ec5ca249db71ab"

  head "git://perl5.git.perl.org/perl.git", :branch => "blead"

  bottle do
    sha256 "dd039ec422108c181e19fcb6e4cf166ff2cfaff6dd0f57640f2a7a292c5fbfad" => :yosemite
    sha256 "525d6a0a33c1bf78330f69ba3b33f218117b49183afd4ead85f3044af4a49cf4" => :mavericks
    sha256 "44ac37fb68bca3ffa86bd6a5ece9ec3e27eac43257bfa2506647bd82d50f8b50" => :mountain_lion
  end

  keg_only :provided_by_osx,
    "OS X ships Perl and overriding that can cause unintended issues"

  option "with-dtrace", "Build with DTrace probes"
  option "with-tests", "Build and run the test suite"

  def install
    args = [
      "-des",
      "-Dprefix=#{prefix}",
      "-Dman1dir=#{man1}",
      "-Dman3dir=#{man3}",
      "-Duseshrplib",
      "-Duselargefiles",
      "-Dusethreads"
    ]

    args << "-Dusedtrace" if build.with? "dtrace"
    args << "-Dusedevel" if build.head?

    system "./Configure", *args
    system "make"
    system "make", "test" if build.with?("tests") || build.bottle?
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    By default Perl installs modules in your HOME dir. If this is an issue run:
      `#{bin}/cpan o conf init`
    EOS
  end

  test do
    (testpath/"test.pl").write "print 'Perl is not an acronym, but JAPH is a Perl acronym!';"
    system "#{bin}/perl", "test.pl"
  end
end
