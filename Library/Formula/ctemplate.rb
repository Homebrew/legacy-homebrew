class Ctemplate < Formula
  desc "Template language for C++"
  homepage "https://ctemplate.googlecode.com/"
  head "http://ctemplate.googlecode.com/svn/trunk/"
  url "http://ctemplate.googlecode.com/svn/tags/ctemplate-2.3/"
  version "2.3"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
