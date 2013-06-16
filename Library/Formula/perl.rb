require 'formula'

class Perl < Formula
  homepage 'http://www.perl.org/'
  url 'http://www.cpan.org/src/5.0/perl-5.18.0.tar.gz'
  sha1 'f5a97a9fa4e9d0ef9c4b313c5b778a0e76291ee2'

  head 'git://perl5.git.perl.org/perl.git'

  devel do
    url 'http://www.cpan.org/src/5.0/perl-5.19.0.tar.gz'
    sha1 'e2a73a07629267f28ec537b01ad847164e2d07df'
    version '5.19.0'
  end

  option 'use-threads', 'Enable Perl threads'
  option 'skip-test', 'Skip `make test` step'

  def install
    args = [
        '-des',
        "-Dprefix=#{prefix}",
        "-Dman1dir=#{man1}",
        "-Dman3dir=#{man3}",
        '-Duseshrplib',
        '-Duselargefiles',
    ]

    args << '-Dusethreads' if build.include? 'use-threads'
    args << '-Dusedevel' if build.devel? or build.head?

    system './Configure', *args
    system "make"
    system "make test" unless build.include? 'skip-test'
    system "make install"
  end

  def caveats
    unless build.include? 'use-threads' then <<-EOS.undent
      Builds without threads by default. Use --use-threads to build with threads.
      Builds with `make test` by default. Use --skip-test to skip `make test` step.
      EOS
    end
  end
end
