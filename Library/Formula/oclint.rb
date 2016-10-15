class Oclint < Formula
  homepage 'http://oclint.org'
  url 'http://archives.oclint.org/releases/0.8/oclint-0.8.1-src.tar.gz'
  version '0.8.1'
  sha256 'fb6dab9ac619bacfea42e56469147cfc40e680642cedf352b87986c0bf1f7510'

  depends_on "cmake" => :build

  def install
    ENV.deparallelize

    system 'pwd'
    system 'ls'
    cd 'oclint-scripts'
    system './make'
    cd '..'
    system 'ls'
    system 'ls build'

    lib.install Dir['build/lib/clang']
    lib.install Dir['build/lib/oclint']
    bin.install Dir['build/bin/*']
  end

  def test
    system "echo \"int main() { return 0; }\" > #{prefix}/test.m"
    system "#{bin}/oclint #{prefix}/test.m -- -c"
  end
end
