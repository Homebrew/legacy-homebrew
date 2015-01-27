class Ny < Formula
  homepage "https://github.com/kenansulayman/ny"
  head "https://github.com/kenansulayman/ny.git"
  url "https://github.com/KenanSulayman/ny/archive/1.3.7.tar.gz"
  sha1 "ff0fbba7bac8f4f77507c23182d4873a67b4e746"

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end
end
