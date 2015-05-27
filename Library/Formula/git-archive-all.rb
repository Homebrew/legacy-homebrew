require 'formula'

class GitArchiveAll < Formula
  homepage 'https://github.com/Kentzo/git-archive-all'
  url 'https://github.com/Kentzo/git-archive-all/archive/1.10.tar.gz'
  sha1 '6627953816c5494e87360cf6c244b1ae71958ae4'

  head 'https://github.com/Kentzo/git-archive-all.git'

  bottle do
    cellar :any
    sha1 "883e8ab977795ea4fb85ac41913e5b3b55a0f25b" => :mavericks
    sha1 "6d7cd0e9d2ab7e9171585d6f121c1817719fc614" => :mountain_lion
    sha1 "6833260e3badad055db6da98c6d308345c10a7d1" => :lion
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
