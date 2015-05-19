require 'formula'

class GitArchiveAll < Formula
  desc "Archive a project and its submodules"
  homepage 'https://github.com/Kentzo/git-archive-all'
  url 'https://github.com/Kentzo/git-archive-all/archive/1.10.tar.gz'
  sha1 '6627953816c5494e87360cf6c244b1ae71958ae4'

  head 'https://github.com/Kentzo/git-archive-all.git'

  bottle do
    cellar :any
    sha256 "dddf1164f9a24ab37c784d906b3d4ffaebb0760951046a9e42f4955a8a2dee08" => :yosemite
    sha256 "3965335a01bdecc405d9cb2bda02e5c430920cca57ccc2f4081e50ea2896ab91" => :mavericks
    sha256 "97400a8e97ab0fe7e42a27e81a1a84eb3c26d5e9113d6a915b677726f4d727d0" => :mountain_lion
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
