require 'formula'

class VeraMan < Formula
  url 'https://bitbucket.org/verateam/vera/downloads/vera++-1.2.0-doc.tar.gz'
  sha1 '3c1dfd167928fb1d7c0d3c55830c7f4d5a2a61ae'
end

class Veraxx < Formula
  homepage 'https://bitbucket.org/verateam/vera'
  url 'https://bitbucket.org/verateam/vera/downloads/vera++-1.2.0.tar.gz'
  sha1 '1c8d8ce92709567d2f0038466bd2be171a27fae2'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
    VeraMan.new.brew do
      man1.install Dir['vera++.1']
      (share+'vera++/doc').install Dir['vera++.html']
    end
  end

  test do
    `#{bin}/vera++ --version`.chomp == '1.2.0'
  end
end
