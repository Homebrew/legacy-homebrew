require 'formula'

class Ice < Formula

  url 'http://www.zeroc.com/download/Ice/3.4/Ice-3.4.2.tar.gz'
  md5 'e97672eb4a63c6b8dd202d0773e19dc7'
  homepage 'http://www.zeroc.com'
<<<<<<< HEAD
=======
  url 'http://www.zeroc.com/download/Ice/3.4/Ice-3.4.2.tar.gz'
  sha1 '8c84d6e3b227f583d05e08251e07047e6c3a6b42'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879

  depends_on 'berkeley-db'
  depends_on 'mcpp'
  # other dependencies listed for Ice are for additional utilities not compiled

  def patches
    # Patch for Ice-3.4.2 to work with Berkely DB 5.X rather than 4.X
    # Patch to solve the upCast problem in current (3.4.2) upstream
    { :p0 => "https://raw.github.com/romainbossart/Hello-World/master/ice_for_clang_2012-03-05.patch", :p1 => [DATA, "https://trac.macports.org/export/94734/trunk/dports/devel/ice-cpp/files/patch-ice.cpp.config.Make.rules.Darwin.diff"] }
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
      s.gsub! "#OPTIMIZE", "OPTIMIZE"
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

__END__
--- ./cpp/src/Freeze/MapI.cpp   
+++ ./cpp/src/Freeze/MapI.cpp                                      
@@ -1487,10 +1487,10 @@ Freeze::MapHelperI::size() const

     try
     {
-#if DB_VERSION_MAJOR != 4
-#error Freeze requires DB 4.x
+#if DB_VERSION_MAJOR < 4
+#error Freeze requires DB 4.x or greater
 #endif
-#if DB_VERSION_MINOR < 3
+#if DB_VERSION_MAJOR == 4 && DB_VERSION_MINOR < 3
         _db->stat(&s, 0);
 #else
         _db->stat(_connection->dbTxn(), &s, 0);
	 
