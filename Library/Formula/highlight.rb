require 'formula'

class Highlight < Formula
  homepage 'http://www.andre-simon.de/doku/highlight/en/highlight.html'
  url 'http://www.andre-simon.de/zip/highlight-3.12.tar.bz2'
  sha1 '4d96b4d91ff08268a338847b9ea408d741b91573'

  depends_on 'pkg-config' => :build
  depends_on 'boost'
  depends_on 'lua'

  def install
    inreplace "src/makefile" do |s|
      s.change_make_var! "CXX", ENV.cxx
      s.gsub! /^(CFLAGS):=.*$/, "\\1 = #{ENV.cppflags}"
      s.gsub! /^(LUA_LIBS)=(.*)$/, "\\1 = #{ENV.ldflags} \\2"
    end

    conf_dir = etc+'highlight/' # highlight needs a final / for conf_dir
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}"
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}", "install"
  end
end
