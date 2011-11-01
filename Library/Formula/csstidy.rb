require 'formula'

class Csstidy < Formula
  head 'http://csstidy.svn.sourceforge.net/svnroot/csstidy/trunk-cpp/'
  homepage 'http://csstidy.sourceforge.net/'

  depends_on 'scons' => :build

  def install
    arch = Hardware.is_64_bit? ? 'x64' : 'ia32'
    system "scons", "-j #{ENV.make_jobs}",
                    "arch=#{arch}"

    bin.install "release/csstidy/csstidy"
  end
end
