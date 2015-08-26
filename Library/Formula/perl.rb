class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "http://www.cpan.org/src/5.0/perl-5.22.0.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/p/perl/perl_5.22.0.orig.tar.xz"
  sha256 "be83ead0c5c26cbbe626fa4bac1a4beabe23a9eebc15d35ba49ccde11878e196"

  head "https://perl5.git.perl.org/perl.git", :branch => "blead"

  bottle do
    sha256 "e4f7a5d1436286b3fd3d992bfd3ccf58b90a8dadcb46153e2899bb8a56e75651" => :yosemite
    sha256 "ffead093930a615a6d1533600eaa46604bba1c776d685e234bbc805f8b767ccb" => :mavericks
    sha256 "e425a96acdc0c709480382addd1c22435c6598fba4b5e6bb6ceaa31e83f9489e" => :mountain_lion
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
