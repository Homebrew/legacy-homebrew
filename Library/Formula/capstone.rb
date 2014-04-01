require 'formula'

class Capstone < Formula
  homepage 'http://capstone-engine.org'
  url 'http://capstone-engine.org/download/2.1.2/capstone-2.1.2.tgz'
  sha1 '235ceab369025fbad9887fe826b741ca84b1ab41'

  def install
    # Fixed upstream in the master tree:
    # https://github.com/aquynh/capstone/commit/869bf7a
    # https://github.com/aquynh/capstone/commit/c7d7884
    ENV["PREFIX"] = prefix
    ENV["HOMEBREW_CAPSTONE"] = "1"
    system "./make.sh"
    system "./make.sh", "install"
  end
end
