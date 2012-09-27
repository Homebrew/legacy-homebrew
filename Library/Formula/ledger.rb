require 'formula'

class Ledger < Formula
  homepage 'http://ledger-cli.org'
  url 'ftp://ftp.newartisans.com/pub/ledger/ledger-2.6.3.tar.gz'
  sha1 '5b8e7d8199acb116f13720a5a469fff1f14b4041'

  head 'https://github.com/jwiegley/ledger.git', :branch => 'next'

  option 'debug', 'Build with debugging symbols enabled'
  option 'python', 'Enable Python support'
  option 'time-colon', 'Apply time-colon patch'

  depends_on 'gettext'
  depends_on 'boost'
  depends_on 'mpfr'
  depends_on 'gmp'
  depends_on 'pcre'
  depends_on 'expat'
  depends_on 'cmake' if build.head?

  def patches
    p = {:p1 => []}
    p[:p1] << 'https://raw.github.com/gist/856799/66158f9f3b732d658f5d0784407ec63a0be33746/ledger_time_colon.patch' if build.include? 'time-colon'
    p
  end

  def install
    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    if build.head?
      args = [((build.include? 'debug') ? 'debug' : 'opt'), "make", "-j#{ENV.make_jobs}", "--output=build"]
      args << '--python' if build.include? 'python'
      system "./acprep", *args
      system "cmake", "-D", "CMAKE_INSTALL_PREFIX=#{prefix}", "-P", "build/cmake_install.cmake"
    else
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system 'make'
      ENV.deparallelize
      system 'make install'
    end
  end
end
