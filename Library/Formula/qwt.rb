require 'formula'

class Qwt < Formula
  url 'http://sourceforge.net/projects/qwt/files/qwt/6.0.1/qwt-6.0.1.tar.bz2'
  homepage 'http://qwt.sourceforge.net/'
  sha1 '301cca0c49c7efc14363b42e082b09056178973e'

  depends_on 'qt'

  def install
    inreplace 'qwtconfig.pri' do |s|
      # change_make_var won't work because there are leading spaces
      s.gsub! /^\s*QWT_INSTALL_PREFIX\s*=(.*)$/, "QWT_INSTALL_PREFIX=#{prefix}"
    end

    system "qmake -spec macx-g++ -config release"
    system "make"
    ENV.j1
    system "make install"

    # The pkg-config files installed suggest that headers can be found in the
    # `include` directory. Make this so by creating symlinks from `include` to
    # the Frameworks' Headers folders.
    include.mkdir
    Pathname.glob(lib + '*.framework/Headers').each do |path|
      framework_name = File.basename(File.dirname(path), '.framework')
      ln_s path.realpath, include+framework_name
    end

  end
end
