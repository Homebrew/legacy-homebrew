require 'formula'

class Hllib < Formula
  homepage 'http://nemesis.thewavelength.net/index.php?p=35'
  url 'http://nemesis.thewavelength.net/files/files/hllib242.zip'
  md5 'd89d53ff40a58062e13d5676fb871742'
  version '2.4.2'

  def install
    # Library
    cd 'HLLib' do
      # Set perms so we can replace the strings
      chmod 0777, 'Makefile'
      inreplace 'Makefile' do |s|
        # Set prefix correctly
        s.gsub! '/usr/local', prefix
        # Remove -soname directive
        s.gsub! '-shared -Wl,-soname,libhl.so.2', '-shared -Wl'
        # Ownership isn't needed here
        s.gsub! %r{ -[og] root}, ''
        # .dylib is the OS X equivalent of .so
        s.gsub! 'libhl.so.$(HLLIB_VERS)', 'libhl.$(HLLIB_VERS).dylib'
        s.gsub! '$(PREFIX)/lib/libhl.so.2', '$(PREFIX)/lib/libhl.2.dylib'
        s.gsub! '$(PREFIX)/lib/libhl.so', '$(PREFIX)/lib/libhl.dylib'
      end
      # Install
      system "make install"
    end
    # Extract tool
    cd 'HLExtract' do
      # Set prefix correctly
      chmod 0777, 'Main.c'
      # Fix limits header for OS X
      inreplace 'Main.c', 'linux/limits.h', 'limits.h'
      # OS X friendly binary name
      inreplace 'Main.c', 'HLExtract.exe', 'hlextract'
      # Make the binary build path and build
      bin.mkpath
      system ENV.cc, 'Main.c', "-I#{include}", "-L#{lib}", '-lhl', '-o', bin+'hlextract'
    end
  end
end
