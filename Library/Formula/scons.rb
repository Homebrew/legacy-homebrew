require "formula"

class Scons < Formula
  homepage "http://www.scons.org"
  url "https://downloads.sourceforge.net/scons/scons-2.3.3.tar.gz"
  sha1 "7bb1c755610613d9dab71bd56267fd1f531a2f97"

  bottle do
    cellar :any
    sha1 "59050aba17abff544a0653a2f12ae41b3ea255a0" => :mavericks
    sha1 "6702ca156e864375ef01518fee9723d4d1110c66" => :mountain_lion
    sha1 "08e0c669f54b07f58d10aa160f0dc9fe75e9bf77" => :lion
  end

  def install
    bin.mkpath # Script won't create this if it doesn't already exist
    man1.install gzip("scons-time.1", "scons.1", "sconsign.1")
    system "/usr/bin/python", "setup.py", "install",
             "--prefix=#{prefix}",
             "--standalone-lib",
             # SCons gets handsy with sys.path---`scons-local` is one place it
             # will look when all is said and done.
             "--install-lib=#{libexec}/scons-local",
             "--install-scripts=#{bin}",
             "--install-data=#{libexec}",
             "--no-version-script", "--no-install-man"

    # Re-root scripts to libexec so they can import SCons and symlink back into
    # bin. Similar tactics are used in the duplicity formula.
    bin.children.each do |p|
      mv p, "#{libexec}/#{p.basename}.py"
      bin.install_symlink "#{libexec}/#{p.basename}.py" => p.basename
    end
  end
end
