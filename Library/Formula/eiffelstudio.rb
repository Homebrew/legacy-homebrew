require "formula"

class Eiffelstudio < Formula
  homepage "https://www.eiffel.com"
  url "https://ftp.eiffel.com/pub/download/14.05/eiffelstudio-14.05.tar"
  sha1 "e0b9d0c4c10f6191e4b0b2ccbb6efc9345c2f950"

  depends_on :x11
  depends_on "pkg-config"
  depends_on "gtk+"

  def install
    system "./compile_exes macosx-x86-64"
    system "./make_images macosx-x86-64"
    system "mv", "Eiffel_14.05/*", "#{prefix}/"
  end

  test do
    system "#{prefix}/studio/spec/macosx-x86-64/bin/ec", "-version"
  end
end
