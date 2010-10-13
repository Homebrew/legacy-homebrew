require 'formula'

class Magit <Formula
  url 'http://github.com/downloads/philjackson/magit/magit-0.8.1.tar.gz'
  homepage 'http://github.com/philjackson/magit'
  md5 'ab5dc15540942dabd9861d9dfaa5601f'
  head 'git://github.com/philjackson/magit.git'

  def install
    system "./autogen.sh" if File.exist? "autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
