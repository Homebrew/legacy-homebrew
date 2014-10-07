require "formula"

class Perl < Formula
  homepage "https://www.perl.org/"
  url "http://www.cpan.org/src/5.0/perl-5.20.1.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/p/perl/perl_5.20.1.orig.tar.bz2"
  sha1 "cd424d1520ba2686fe5d4422565aaf880e9467f6"

  head "git://perl5.git.perl.org/perl.git", :branch => "blead"

  keg_only "OS X ships Perl and overriding that can cause unintended issues"

  option "with-dtrace", "Build with DTrace probes"

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
    system "make", "test"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    By default Perl installs modules in your HOME dir. If this is an issue run:
    #{bin}/cpan o conf init
    EOS
  end

  test do
    (testpath/"test.pl").write "print 'Perl is not an acronym, but JAPH is a Perl acronym!';"
    system "#{bin}/perl", "test.pl"
  end
end
