require 'formula'

class Yajl <Formula
  @homepage='http://lloyd.github.com/yajl/'
  @url='http://github.com/lloyd/yajl/tarball/1.0.6'
  @md5='bb201150143352b117be702a1bc78405'

  depends_on 'cmake'

  def install
    ENV.deparallelize

    # I have pushed this fix upstream
    inreplace 'configure', 'cmake ..', "cmake #{std_cmake_parameters} .." if @version == "1.0.5"

    system "./configure --prefix '#{prefix}'"
    system "make install"
  end
end
