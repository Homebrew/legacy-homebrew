require 'formula'

class Dtrx < Formula
  homepage 'http://brettcsmith.org/2007/dtrx/'
  url 'http://brettcsmith.org/2007/dtrx/dtrx-7.1.tar.gz'
  sha1 '05cfe705a04a8b84571b0a5647cd2648720791a4'

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test dtrx`.
    system "dtrx"
  end
end
