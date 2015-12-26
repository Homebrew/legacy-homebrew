class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "http://www.cpan.org/src/5.0/perl-5.22.0.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/p/perl/perl_5.22.0.orig.tar.xz"
  sha256 "be83ead0c5c26cbbe626fa4bac1a4beabe23a9eebc15d35ba49ccde11878e196"

  head "https://perl5.git.perl.org/perl.git", :branch => "blead"

  bottle do
    revision 1
    sha256 "ebb13b34c8f16e00bc2c1f27b58e1429ffed46ab62fc985daba01995cb634718" => :el_capitan
    sha256 "f856738f95e476155e396ce666aa03daeb02d8b69584310b089e5ad2ba16dfd6" => :yosemite
    sha256 "54ae891865a973f2f8cea6639eb52fa2bad39ad7a31d9c04f255de52bc85ae58" => :mavericks
  end

  keg_only :provided_by_osx,
    "OS X ships Perl and overriding that can cause unintended issues"

  option "with-dtrace", "Build with DTrace probes"
  option "with-test", "Build and run the test suite"

  deprecated_option "with-tests" => "with-test"

  def install
    args = %W[
      -des
      -Dprefix=#{prefix}
      -Dman1dir=#{man1}
      -Dman3dir=#{man3}
      -Duseshrplib
      -Duselargefiles
      -Dusethreads
    ]

    args << "-Dusedtrace" if build.with? "dtrace"
    args << "-Dusedevel" if build.head?

    system "./Configure", *args
    system "make"

    # OS X El Capitan's SIP feature prevents DYLD_LIBRARY_PATH from being passed to child
    # processes, which causes the make test step to fail.
    # https://rt.perl.org/Ticket/Display.html?id=126706
    # https://github.com/Homebrew/homebrew/issues/41716
    if MacOS.version < :el_capitan
      system "make", "test" if build.with?("test") || build.bottle?
    end

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
