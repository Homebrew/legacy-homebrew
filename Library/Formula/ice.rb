require 'formula'

class Ice < Formula
  homepage 'http://www.zeroc.com'
  url 'http://www.zeroc.com/download/Ice/3.4/Ice-3.4.2.tar.gz'
  sha1 '8c84d6e3b227f583d05e08251e07047e6c3a6b42'

  depends_on 'berkeley-db'
  depends_on 'mcpp'

  # * compile against Berkely DB 5.X
  # * use our selected compiler
  def patches
    [
      "https://trac.macports.org/export/94734/trunk/dports/devel/ice-cpp/files/patch-ice.cpp.config.Make.rules.Darwin.diff",
      DATA
    ]
  end

  def site_package_dir
    "#{which_python}/site-packages"
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  option 'doc', 'Install documentation'
  option 'demo', 'Build demos'
  option 'java', 'Build java library'
  option 'python', 'Build python library'


  # See:
  # http://www.zeroc.com/forums/bug-reports/4965-slice2cpp-output-does-not-compile-standards-conformant-compiler.html
  fails_with :clang do
    build 318
    cause <<-EOS.undent
      In file included from BuiltinSequences.cpp:23:
      In file included from ../../include/Ice/BuiltinSequences.h:30:
      ../../include/Ice/Stream.h:545:19: error: invalid use of incomplete type 'Ice::MarshalException'
                  throw MarshalException(__FILE__, __LINE__, "enumerator out of range");
      (and many other errors)
    EOS
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
    wb += ' doc' if build.include? 'doc'
    wb += ' demo' if build.include? 'demo'
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
        # Leave the jars in the cellar for now
        # Dir.chdir "lib" do
        #   lib.install ['Ice.jar', 'ant-ice.jar']
        # end
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
