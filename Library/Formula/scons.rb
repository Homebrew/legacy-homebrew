require "formula"

class Scons < Formula
  homepage "http://www.scons.org"
  url "https://downloads.sourceforge.net/scons/scons-2.3.4.tar.gz"
  sha1 "8c55f8c15221c1b3536a041d46056ddd7fa2d23a"

  bottle do
    cellar :any
    sha1 "9d69276a41e5e8f52e241cd9047135a06f837651" => :mavericks
    sha1 "d7c2ace93bcfde40f21913ed3a7929d426a78b4c" => :mountain_lion
    sha1 "a86c4a457e6925be8d0ae2645c36b019ad315307" => :lion
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
