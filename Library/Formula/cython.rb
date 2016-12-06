require 'formula'

class Cython < Formula
  homepage 'http://www.cython.org'
  url 'http://www.cython.org/release/Cython-0.17.2.tar.gz'
  sha1 'c156f32f797480b0f7db3ba9dec183bd1e471259'

  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  def test
    # This is a fast, lax test:
    system "cython", "--version"

    # Here is a much more thorough test.
    # WARNING: it takes a LONG time (tens of minutes).
    # It also generates lots of compile warnings that should be ignored.
    #system "python", "runtests.py"
  end
end
