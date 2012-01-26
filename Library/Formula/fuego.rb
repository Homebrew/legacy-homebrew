require 'formula'

class Fuego < Formula
  url 'http://downloads.sourceforge.net/project/fuego/fuego/1.1/fuego-1.1.tar.gz'
  homepage 'http://fuego.sourceforge.net/'
  sha1 'bfbdffc7d4950fe1f451abad3cb76572c5e9d344'

  depends_on 'boost'

  def options
    [[ '--with-test', 'Verify the build during install using make check. (~25sec)' ]]
  end

  def patches
    # Feugo is coded against an earlier verion than the current boost-1.47.0
    # Patch for fuegomain/FuegoMain.cpp fixes two compile errors:
    #   1 - replace deprecated boost function branch_path()
    #   2 - fix a call to path() with two arguments where gcc can't
    #       interpret the second argument.
    # http://www.boost.org/doc/libs/1_47_0/libs/filesystem/v3/doc/deprecated.html
    'https://raw.github.com/gist/1318730'
  end

  def install

    if ENV.use_clang? then
      opoo <<-EOS.undent
        Compilation fails with clang due to references being declared mutable.
            mutable SgPointSet& m_pointSet; // allow temp objects to modify
            ^
        Switching the compiler to llvm and continuing the install for you.
      EOS
      ENV.llvm
    end

    # Change deprecated boost functions to their official replacements.
    inreplace 'fuegomain/FuegoMainUtil.cpp', 'native_file_string', 'string'
    inreplace 'go/GoGtpEngine.cpp', 'native_file_string', 'string'
    # Remove deprecated normalize() function.  Boost removed it because it's unsafe.
    # The result is: Paths with a . or a .. or a symlink will be left with those intact.
    inreplace 'fuegomain/FuegoMainUtil.cpp', 'normalizedFile.normalize', '//normalizedFile.normalize'

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make check" if ARGV.include? '--with-test'
    system "make install"
    doc.install 'doc/manual/index.html'
  end
end
