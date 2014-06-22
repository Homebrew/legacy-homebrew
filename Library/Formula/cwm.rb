require "formula"

class Cwm < Formula
  homepage "https://github.com/chneukirchen/cwm"
  url "https://github.com/chneukirchen/cwm/archive/v5.5.tar.gz"
  sha1 "0e21a48b4973beb7ddf265bea48b73b0c39a589e"

  depends_on :x11
  depends_on "pkg-config" => :build

  patch do
    # Remove this patch when updating to the next cwm release 5.6,
    # where it is already contained.
    url "https://github.com/chneukirchen/cwm/commit/c7f481e6fac2cb693144bff45f6180d146bf13a5.diff"
    sha1 "b91bd1b14fe9d4fef287be19eabc05762e5cf047"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end
end
