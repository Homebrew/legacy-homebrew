require 'formula'

class Subgit < Formula
  homepage 'http://www.subgit.com'
  url 'http://www.subgit.com/download/subgit-2.0.0.zip'
  sha1 '6c457d57b0f71a5b619a460108236e3c061a38c2'

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
