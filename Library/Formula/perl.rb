class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "http://www.cpan.org/src/5.0/perl-5.22.1.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/p/perl/perl_5.22.1.orig.tar.xz"
  sha256 "2b475d0849d54c4250e9cba4241b7b7291cffb45dfd083b677ca7b5d38118f27"

  head "https://perl5.git.perl.org/perl.git", :branch => "blead"

  bottle do
    sha256 "a1bbae429655d663bfa47ccad7ec10b0412f07702abf1ed442ccc37e014de3bb" => :el_capitan
    sha256 "0e7a6aea826e32f2f3b77a1889a26457dfb8d72e6382d350590f8391b89ef3d4" => :yosemite
    sha256 "b6c3b4aa11cd78191840029502763b9249c74e63d58412a82854fec4350ac5a3" => :mavericks
  end

  keg_only :provided_by_osx,
    "OS X ships Perl and overriding that can cause unintended issues"

  option "with-dtrace", "Build with DTrace probes"
  option "without-test", "Skip running the build test suite"

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
      system "make", "test" if build.with? "test"
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
