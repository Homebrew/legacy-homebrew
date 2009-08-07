require 'brewkit'

class Yajl <Formula
  @homepage='http://lloyd.github.com/yajl/'
  @url='http://github.com/lloyd/yajl/tarball/1.0.5'
  @md5='f4a3cbc764c43231ed1aedc54438b69b'

  def deps
    BinaryDep.new 'cmake'
  end

  def install
    ENV.deparallelize

    # I have pushed this fix upstream
    inreplace 'configure', 'cmake \.\.', "cmake -DCMAKE_INSTALL_PREFIX='#{prefix}' \.\." if @version == "1.0.5"

    system "./configure --prefix '#{prefix}'"
    system "make install"
  end
end