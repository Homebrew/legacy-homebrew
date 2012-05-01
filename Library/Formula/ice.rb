require 'formula'

class Ice < Formula
  url 'http://www.zeroc.com/download/Ice/3.4/Ice-3.4.1.tar.gz'
  homepage 'http://www.zeroc.com'
  md5 '3aae42aa47dec74bb258c1a1b2847a1a'

  depends_on 'berkeley-db'
  depends_on 'mcpp'

  # Patch for Ice-3.4.1 to work with Berkely DB 5.X.
  def patches; DATA; end

  def options
    [
      ['--doc', 'Install documentation'],
      ['--demo', 'Build demos']
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
