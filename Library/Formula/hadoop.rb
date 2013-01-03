require 'formula'

class Hadoop < Formula
  homepage 'http://hadoop.apache.org/common/'
  url 'http://www.apache.org/dyn/closer.cgi?path=hadoop/core/hadoop-2.0.2-alpha/hadoop-2.0.2-alpha.tar.gz'
  sha1 '44206b2d4b657a8efa47dbe78725c58233e17a9d'
  version '2.0.2'

  def install
    libexec.install %w[bin lib libexec share]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
    # But don't make rcc visible, it conflicts with Qt
    (bin/'rcc').unlink
  end
end
