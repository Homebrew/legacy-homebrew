require 'formula'

class Cython < Formula
  homepage 'http://cython.org'
  url 'http://cython.org/release/Cython-0.20.1.tar.gz'
  mirror 'https://github.com/cython/cython/archive/0.20.1.tar.gz'
  sha1 'e0f2c2094722bada54f24c33f5c792411778ba4f'

  head 'https://github.com/cython/cython.git'

  option 'docs', 'Build/install cython manpage and documentation with Sphinx.'
  option 'no-compile', 'Do not compile. Fastest install, slowest to run.'
  option 'all-compile', 'Compile all code. Very slow build; fastest compiler.'

  depends_on :python
  depends_on 'sphinx' => :python if build.include? 'docs'

  def install
    ENV.append 'CFLAGS', '-Qunused-arguments' if ENV.compiler == :clang

    (share/'cython').install Dir['*']

    cd share/'cython' do
      mv 'setupegg.py', 'cymake'

      if build.include? 'docs'
        sphinxexe = 'import sys; from sphinx import main; main(sys.argv)'
        sphinxbld = "echo '#{sphinxexe}' | python - -b"
        system "#{sphinxbld} man docs #{man1}"
        system "#{sphinxbld} html docs #{doc}"
        rm_rf  "#{man1}/.doctrees"
      end

      if build.include? 'all-compile'
        inreplace 'Makefile', '--inplace', '--inplace --cython-compile-all'
      end

      system 'make' unless build.include? 'no-compile'

      cd 'bin' do
        %w(cython cygdb cython.bat).each { |f| rm_rf f }
        %w(cython_freeze cythonize cythonrun).each { |f| mv f, '..' }
      end

      %w(INSTALL.txt MANIFEST.in Makefile ToDo.txt bin pylintrc runtests.py
         setup.py setupegg.py).each { |f| rm_rf f }

      mkdir bin do
        %w(cython_freeze cythonize cythonrun cython.py cygdb.py).each { |exe|
           ln_s "../share/cython/#{exe}", "#{bin}" }
        mv 'cygdb.py', 'cygdb'
        mv 'cython.py', 'cython'
      end
    end
  end
end
