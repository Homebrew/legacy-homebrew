require 'formula'

class Luvit < Formula
  homepage 'http://luvit.io'
  url 'http://luvit.io/dist/latest/luvit-0.6.1.tar.gz'
  sha1 'f5e49a33e0e32d8e75d5cdd843d54f213f6e508e'
  head 'https://github.com/luvit/luvit.git'

  def install
    ENV['PREFIX'] = prefix
    system './configure'
    system 'make'
    system 'make', 'install'
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test luvit`.
    system 'make', 'test'
  end
end
