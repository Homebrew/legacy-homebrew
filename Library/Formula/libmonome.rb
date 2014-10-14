require 'formula'

class Libmonome < Formula
  homepage 'http://illest.net/libmonome/'
  url 'https://github.com/monome/libmonome/archive/1.2.tar.gz'
  sha1 'a53a232a7b24614c865b7cb536f80cb0219ff1d1'

  head 'https://github.com/monome/libmonome.git'

  bottle do
    sha1 "9aa228d474a66e05881bb181469803a6a315cdaa" => :mavericks
    sha1 "8015b84c94442cb21cf546e3c10214f237a5e181" => :mountain_lion
    sha1 "f7ff9f61f8254cd0d0279d897aadb7197511a6bc" => :lion
  end

  depends_on 'liblo'

  def install
    inreplace 'wscript', '-Werror', ''
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf build"
    system "./waf install"
  end
end
