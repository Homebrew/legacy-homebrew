require "formula"

class Scons < Formula
  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "http://www.scons.org"
  url "https://downloads.sourceforge.net/scons/scons-2.3.5.tar.gz"
  sha256 "5b72f959cafbef81f408b503bc8e8d5cfc39f41fb5b629e9ff13bdf20a3eefe2"

  bottle do
    cellar :any
    revision 1
    sha1 "819d08b7e8c1ba2451db6d7d848f689b108b40aa" => :yosemite
    sha1 "629c8e7a23a3ca5378a42ccce3472f36f54f8360" => :mavericks
    sha1 "38882a9e4002c6c5b7e35df8613fb2bf6720f3b1" => :mountain_lion
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
