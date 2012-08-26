require 'formula'

class TexInstalled < Requirement
  def message; <<-EOS.undent
    A TeX/LaTeX installation is required to install.
    You can obtain the TeX distribution for Mac OS X from:
        http://www.tug.org/mactex/
    After you install it, put its bin in your PATH and open a new Terminal tab.
    You should also do this because MacTex installs with root ownership:
        sudo chown -R $USER `brew --prefix`
    That will change all the files and directories back to being owned by you.
    EOS
  end
  def satisfied?
    which 'mpost'
  end
  def fatal?
    true
  end
end

class PythonCompilerIsLLVM < Requirement
  def python_compiler
    `python -c "import distutils.sysconfig as c; print(c.get_config_var('MAINCC'))"`.chomp
  end

  def message
    <<-EOS.undent
      Your python was compiled with #{python_compiler}
      Lilypond has an issue where it mixes compile flags with Python.  So both
      Lilypond and Python need to be built with the same compiler.  Please rebuild
      your Homebrew Python with llvm because we detected you built it with clang.
          brew rm -f python
          brew install --use-llvm --framework python
    EOS
  end
  def satisfied?
    if python_compiler.empty? or (Formula.factory('python').installed? and python_compiler.include? 'clang')
      false
    else
      true
    end
  end
  def fatal?
    true
  end
end

class Lilypond < Formula
  homepage 'http://lilypond.org/'
  url 'http://download.linuxaudio.org/lilypond/sources/v2.14/lilypond-2.14.2.tar.gz'
  sha1 '0ea657bb184d9d6a2e3f6bca91e6b0d62a3a013e'

  devel do
    url 'http://download.linuxaudio.org/lilypond/sources/v2.15/lilypond-2.15.41.tar.gz'
    sha1 '634b699ffd6cec9e0595051656dba02960798716'
  end

  depends_on TexInstalled.new
  depends_on PythonCompilerIsLLVM.new
  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'pango'
  depends_on 'guile'
  depends_on 'ghostscript'
  depends_on 'mftrace'
  depends_on 'fontforge'
  depends_on 'texinfo'
  depends_on :x11

  skip_clean :all

  fails_with :clang do
    build :all
    cause 'Strict C99 compliance error in a pointer conversion.'
  end

  def install
    gs = Formula.factory('ghostscript')
    system "./configure", "--prefix=#{prefix}", "--enable-rpath",
                          "--with-ncsb-dir=#{gs.share}/ghostscript/fonts/"

    # Separate steps to ensure that lilypond's custom fonts are created.
    system 'make all'
    system "make install"
  end

  def test
    mktemp do
      (Pathname.pwd+'test.ly').write <<-EOS.undent
        \\version "2.14.1"
        \\header { title = "Do-Re-Mi" }
        { c' d' e' }
      EOS
      lilykeg = Formula.factory('lilypond').linked_keg
      system "#{lilykeg}/bin/lilypond test.ly && /usr/bin/qlmanage -p test.pdf"
    end
  end
end
