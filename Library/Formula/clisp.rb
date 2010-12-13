require 'formula'

class Clisp <Formula
  url 'http://ftp.gnu.org/pub/gnu/clisp/release/2.49/clisp-2.49.tar.bz2'
  homepage 'http://clisp.cons.org/'
  md5 '1962b99d5e530390ec3829236d168649'

  depends_on 'libiconv'
  depends_on 'libsigsegv'
  depends_on 'readline'

  skip_clean :all # otherwise abort trap

  def install
    # This build isn't parallel safe.
    ENV.j1

    # Clisp requires to select word size explicitly this way,
    # set it in CFLAGS won't work.
    ENV['CC'] = "#{ENV.cc} -m#{snow_leopard_64? ? 64 : 32}"

    system "./configure", "--prefix=#{prefix}",
                          "--with-readline=yes"

    cd "src" do
      # Multiple -O options will be in the generated Makefile,
      # make Homebrew's the last such option so it's effective.
      inreplace "Makefile" do |s|
        cf = s.get_make_var("CFLAGS")
        cf.gsub! ENV['CFLAGS'], ''
        cf += ' '+ENV['CFLAGS']
        s.change_make_var! 'CFLAGS', cf
      end

      # The ulimit must be set, otherwise `make` will fail and tell you to do so
      system "ulimit -s 16384 && make"

      # Considering the complexity of this package, a self-check is highly recommended.
      system "make check"
      system "make install"
    end
  end

  def test
    system "clisp --version"
  end
end
