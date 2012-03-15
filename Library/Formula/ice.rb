require 'formula'

class Ice < Formula

  url 'http://www.zeroc.com/download/Ice/3.4/Ice-3.4.2.tar.gz'
  md5 'e97672eb4a63c6b8dd202d0773e19dc7'
  homepage 'http://www.zeroc.com'

  depends_on 'berkeley-db'
  depends_on 'mcpp'
  # other dependencies listed for Ice are for additional utilities not compiled

  def patches
    # Patch for Ice-3.4.2 to work with Berkely DB 5.X rather than 4.X
    "https://raw.github.com/gist/1619052/5be2a4bed2d4f1cf41ce9b95141941a252adaaa2/Ice-3.4.2-db5.patch"
  end

  def site_package_dir
    "#{which_python}/site-packages"
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  def options
    [
      ['--doc', 'Install documentation'],
      ['--demo', 'Build demos'],
      ['--java', 'Build java library'],
      ['--python', 'Build python library']
    ]
  end

  def install
    ENV.O2
    inreplace "cpp/config/Make.rules" do |s|
      s.gsub! "/opt/Ice-$(VERSION)", prefix
      s.gsub! "/opt/Ice-$(VERSION_MAJOR).$(VERSION_MINOR)", prefix
    end

    # what want we build?
    wb = 'config src include'
    wb += ' doc' if ARGV.include? '--doc'
    wb += ' demo' if ARGV.include? '--demo'

    inreplace "cpp/Makefile" do |s|
      s.change_make_var! "SUBDIRS", wb
    end

    inreplace "cpp/config/Make.rules.Darwin" do |s|
      s.change_make_var! "CXXFLAGS", "#{ENV.cflags} -Wall -D_REENTRANT"
    end

    cd "cpp" do
      system "make"
      system "make install"
    end

    if ARGV.include? '--java'
      Dir.chdir "java" do
        system "ant ice-jar"
        Dir.chdir "lib" do
          lib.install ['Ice.jar', 'ant-ice.jar']
        end
      end
    end

    if ARGV.include? '--python'

      inreplace "py/config/Make.rules" do |s|
        s.gsub! "/opt/Ice-$(VERSION)", prefix
        s.gsub! "/opt/Ice-$(VERSION_MAJOR).$(VERSION_MINOR)", prefix
      end

      Dir.chdir "py" do
        system "make"
        system "make install"
      end

      # install python bits
      Dir.chdir "#{prefix}/python" do
        (lib + site_package_dir).install Dir['*']
      end
    end

  end
end
