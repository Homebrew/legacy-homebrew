require 'formula'

class Parsley <Formula
  head 'git://github.com/fizx/parsley.git'
  homepage 'http://github.com/fizx/parsley'

  depends_on 'json-c'
  depends_on 'pcre'
  depends_on 'argp-standalone'

  def install
    argp = Formula.factory("argp-standalone").prefix

    # remove the refs to /opt/local and use this opportunity to link to argp
    inreplace 'configure', '-L/opt/local/lib', "-L#{argp}"
    inreplace 'configure', '-I/opt/local/include', "-I#{argp}"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
