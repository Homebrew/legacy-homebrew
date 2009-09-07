require 'brewkit'

class TaglibExtras <Formula
  @url='http://kollide.net/~jefferai/taglib-extras-0.1.6.tar.gz'
  @md5='706a82fe4c25606f731faf4c14b5edb0'
end

class Taglib <Formula
  @url='http://developer.kde.org/~wheeler/files/src/taglib-1.5.tar.gz'
  @md5='7b557dde7425c6deb7bbedd65b4f2717'
  @homepage='http://developer.kde.org/~wheeler/taglib.html'

  def deps
    'cmake'
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