require 'formula'

class Parsley < Formula
  head 'git://github.com/fizx/parsley.git'
  homepage 'https://github.com/fizx/parsley'

  depends_on 'json-c'
  depends_on 'pcre'
  depends_on 'argp-standalone'

  def install
    argp = Formula.factory("argp-standalone").prefix

    # remove the refs to /opt/local and use this opportunity to link to argp
    inrepace "configure" do |s|
      s.gsub! '-L/opt/local/lib', "-L#{argp}"
      s.gsub! '-I/opt/local/include', "-I#{argp}"
    end

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
