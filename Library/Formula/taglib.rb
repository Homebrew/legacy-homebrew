require 'brewkit'

class TaglibExtras <Formula
  @url='http://kollide.net/~jefferai/taglib-extras-0.1.7.tar.gz'
  @md5='09bf9c89d953a238b55ac74bf9db0be3'
end

class Taglib <Formula
  @url='http://developer.kde.org/~wheeler/files/src/taglib-1.5.tar.gz'
  @md5='7b557dde7425c6deb7bbedd65b4f2717'
  @homepage='http://developer.kde.org/~wheeler/taglib.html'

  def deps
    BinaryDep.new 'cmake'
  end

  def install
    system "./configure --disable-debug --prefix='#{prefix}'"
    system "make install"
    
    TaglibExtras.new.brew do
      system "cmake . #{std_cmake_parameters}"
      system "make install"
    end unless ARGV.include? '--no-extras'
  end
end