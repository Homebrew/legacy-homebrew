require 'formula'

class Namebench < Formula
  homepage 'https://code.google.com/p/namebench/'
  url 'https://namebench.googlecode.com/files/namebench-1.3.1-source.tgz'
  sha1 '2e6ca5a4f20512cb967c5ac43b023cc38c271131'

  depends_on :python

  option 'no-third-party', 'Do not install bundled third-party modules'

  def install
    ENV['NO_THIRD_PARTY']='1' if build.include?('no-third-party')

    system "python", "setup.py", "install", "--prefix=#{prefix}",
                                            "--install-data=#{lib}/python2.7/site-packages"

    bin.install bin/'namebench.py' => 'namebench'
  end
end
