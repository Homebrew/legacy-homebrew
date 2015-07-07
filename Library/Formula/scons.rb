require "formula"

class Scons < Formula
  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "http://www.scons.org"
  url "https://downloads.sourceforge.net/scons/scons-2.3.5.tar.gz"
  sha256 "5b72f959cafbef81f408b503bc8e8d5cfc39f41fb5b629e9ff13bdf20a3eefe2"

  bottle do
    cellar :any
    sha256 "1f99ce6c3eeb9df4b503c470c982e00f394be3f813729e800ad4ca249b4c4e6d" => :yosemite
    sha256 "b2e5ffe24de2dd6d62da181c03b968d4f9c3eae41096e6d4bd0a2c480fb1ada1" => :mavericks
    sha256 "308d20365203d26f64c56187c3e4d7b8bec3a4c160dd1005d96544b07a03cdbd" => :mountain_lion
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
