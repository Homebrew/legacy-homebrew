require 'formula'

# Newer version of autoconf required to compile Macaulay2
class Autoconf < Formula
  url 'http://ftp.gnu.org/gnu/autoconf/autoconf-2.68.tar.gz'
  homepage 'http://www.gnu.org/software/autoconf/'
  md5 'c3b5247592ce694f7097873aa07d66fe'
end

class Macaulay2 < Formula
  depends_on 'gnu-tar'
  depends_on 'bdw-gc'
  depends_on 'mpfr'
  depends_on 'gdbm'
  depends_on 'glpk'

  revision = '13916'

  url 'svn://svn.macaulay2.com/Macaulay2/release-branches/1.4', :revision => revision
  head 'svn://svn.macaulay2.com/Macaulay2/trunk/M2'
  homepage 'http://www.macaulay2.com/'
  version "1.4-#{revision}"

  keg_only <<-EOS
Macaulay2 is installed keg-only, to suport side-by-side installations.
EOS

  def options
    [['--test', "Run tests before installation"]]
  end

  def install

    #   temporarily install autoconf
    autoconf_prefix = Pathname.pwd.join('autoconf-install')
    Autoconf.new.brew do |f|
      system "./configure", "--prefix=#{autoconf_prefix}"
      system "make install"
    end

    #   install Macaulay2
    ENV.deparallelize
    ENV.prepend "PATH", "#{autoconf_prefix}/bin", ":"
    system "make"
    system "mkdir BUILD/normal"
    Dir.chdir("BUILD/normal")
    system "../../configure", "--prefix=#{prefix}", "--enable-download"
    system "make"
    if ARGV.include? '--test'
      system "make check"
    end
    system "make install"

  end

  def caveats; <<-EOS
This formula supports multiple, side-by-side installations.
To install the stable release #{version}, use the command

    brew install macaulay2

To also run the tests before installation, use the command

    brew install --test macaulay2

To install the latest daily build, use the command

    brew install --force --HEAD macaulay2

If there is only one installed version, then to create or remove
symlinks in /usr/local, use the commands

    brew link macaulay2
    brew unlink macaulay2

To set up your environment variables to find Macaulay2, use one of

    M2="#{HOMEBREW_CELLAR}/macaulay2/#{version}"
    M2="#{HOMEBREW_CELLAR}/macaulay2/HEAD"
    M2="/usr/local"

and then use as needed

    PATH="$M2/bin:$PATH"
    MANPATH="$M2/share/man:$MANPATH"
    INFOPATH="$M2/share/info:$INFOPATH"
    export PATH MANPATH INFOPATH

EOS
  end

end
