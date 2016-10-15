require "formula"

class Bzip2 < Formula
  homepage "http://www.bzip.org/"
  url "http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz"
  sha1 "3f89f861209ce81a6bab1fd1998c0ef311712002"

  keg_only "bzip2 contains bziplib.h which shadows a system header"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    system "mkdir", "-p", man
    system "mv", "#{prefix}/man", man
  end

  test do
    testfilepath = File.path(testpath) +
      File.path(File::Separator) +
      "sample_in.txt"
    zipfilepath = testfilepath + ".bz2"

    print testfilepath + "\n"
    File.open(testfilepath, 'w') { |file| file.write("TEST CONTENT") }

    system "bzip2", testfilepath
    system "bunzip2", zipfilepath

    content = ""
    File.open(testfilepath, 'r') { |file| content = file.read() }

    if content == "TEST CONTENT" then
      system "true"
    else
      systen "false"
    end
  end
end
