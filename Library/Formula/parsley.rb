require 'formula'

class ArgpStandalone <Formula
  url 'http://www.lysator.liu.se/~nisse/misc/argp-standalone-1.3.tar.gz'
  homepage 'http://www.freshports.org/devel/argp-standalone/?ref=darwinports.com'
  md5 '720704bac078d067111b32444e24ba69'
end

class Parsley <Formula
  head 'git://github.com/fizx/parsley.git'
  homepage 'http://github.com/fizx/parsley'

  depends_on 'json-c'
  depends_on 'pcre'

  def install
    argpwd = Pathname.getwd+'argp'
    argpwd.mkpath

    ArgpStandalone.new.brew do
        system "./configure", "--disable-debug", "--disable-dependency-tracking",
               "--prefix=#{argpwd}"
        system "make"
        argpwd.install ["libargp.a"]
        argpwd.install ["argp.h", "argp-fmtstream.h", "argp-namefrob.h"]
    end

    # remove the refs to /opt/local and use this opportunity to link to argp
    inreplace 'configure', '-L/opt/local/lib', "-L#{argpwd}"
    inreplace 'configure', '-I/opt/local/include', "-I#{argpwd}"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
