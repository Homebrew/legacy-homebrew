require 'formula'

class Scons < Formula
  homepage 'http://www.scons.org'
  url 'https://downloads.sourceforge.net/scons/scons-2.3.1.tar.gz'
  sha1 '775e715e49fe5fd8e1d29551a296fdc9267509e7'

  bottle do
    cellar :any
    revision 3
    sha1 "e95727216cded8197acd0cf2d77a078ba1a4ed05" => :mavericks
    sha1 "b8ffa3da1b9378944a5b97c2783c1a8593331539" => :mountain_lion
    sha1 "c4d0bd20be297fc6d3eb615abe22b78212a91655" => :lion
  end

  def install
    bin.mkpath # Script won't create this if it doesn't already exist
    man1.install gzip('scons-time.1', 'scons.1', 'sconsign.1')
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
