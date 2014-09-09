require 'formula'

class Lmdb < Formula
  homepage 'http://symas.com/mdb/'
  url "https://gitorious.org/mdb/mdb.git", :tag => "LMDB_0.9.13"

  head 'git://git.openldap.org/openldap.git', :branch => 'mdb.master'

  bottle do
    cellar :any
    sha1 "55a9e7543df012aa3e9431805c8e55d00597f6f5" => :mavericks
    sha1 "fbfc5f6cbe2ec4799cfa153672217a028374bcb2" => :mountain_lion
    sha1 "61d3a5414a97a5e69b91aea6fbf108c192cde088" => :lion
  end

  def install
    inreplace "libraries/liblmdb/Makefile" do |s|
      s.gsub! ".so", ".dylib"
      s.gsub! "$(DESTDIR)$(prefix)/man/man1", "$(DESTDIR)$(prefix)/share/man/man1"
    end

    man1.mkpath
    bin.mkpath
    lib.mkpath
    include.mkpath

    system "make", "-C", "libraries/liblmdb", "install", "prefix=#{prefix}"
  end
end
