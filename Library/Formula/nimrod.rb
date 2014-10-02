require 'formula'

class Nimrod < Formula
  homepage "http://nimrod-lang.org"
  url "https://github.com/Araq/Nimrod/archive/v0.9.4.tar.gz"
  sha1 "7b37573b474030324c627c203359c51b18d3fae8"

  resource "csources" do
    url "https://github.com/nimrod-code/csources/archive/v0.9.4.tar.gz"
    sha1 "748e2ec690c2833fde9298e1a61939f2aa3f3938"
  end

  def install
    resource("csources").stage do
      # We need this bin later
      inreplace "build.sh", "binDir=bin", "binDir=#{buildpath}/bin"
      system "/bin/sh", "build.sh"
    end

    system "./bin/nimrod", "compile", "koch"
    system "./koch", "boot", "-d:release"

    # Remove nimrod suffix from install paths
    inreplace "tools/niminst/install.tmpl", "$1/?proj", "$1" 
    system "./koch", "install", "#{prefix}"
  end

  test do
    (testpath/'hello.nim').write <<-EOS.undent
      echo("Hi!")
    EOS
    system "nimrod", "compile", "--run", "hello.nim"
  end
end
