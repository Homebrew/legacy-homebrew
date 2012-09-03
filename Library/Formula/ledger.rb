require 'formula'

class Ledger < Formula
  homepage 'http://ledger-cli.org'
  url 'ftp://ftp.newartisans.com/pub/ledger/ledger-2.6.3.tar.gz'
  sha1 '5b8e7d8199acb116f13720a5a469fff1f14b4041'

  head 'https://github.com/jwiegley/ledger.git', :branch => 'next'

  option 'no-python', 'Disable Python support'

  depends_on 'gettext'
  depends_on 'boost'
  depends_on 'mpfr'
  depends_on 'gmp'
  depends_on 'pcre'
  depends_on 'expat'

  def install
    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    if build.head?
      # gmp installs x86_64 only
      inreplace 'acprep', "'-arch', 'i386', ", "" if Hardware.is_64_bit?
      no_python = ((build.include? 'no-python') ? '--no-python' : '')
      system "./acprep", no_python, "-j#{ENV.make_jobs}", "opt", "make", "--", "--prefix=#{prefix}"
    else
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
    end
    system 'make'
    ENV.deparallelize
    system 'make install'
  end
end
