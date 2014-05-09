require "formula"

class Ruby19Dependency < Requirement
  fatal true

  satisfy do
    `ruby --version` =~ /ruby (\d\.\d).\d/
    $1.to_f >= 1.9
  end

  def message
    "Selecta requires Ruby 1.9 or better."
  end
end

class Betty < Formula
  homepage "https://github.com/pickhardt/betty"
  url "https://github.com/pickhardt/betty/archive/v0.1.4.tar.gz"
  sha1 "f31c4ab02036e82b07116b821193e32287029908"
  version "0.1.4"

  depends_on Ruby19Dependency

  def install
    libexec.install 'lib', 'main.rb' => 'betty'
    (libexec/'betty').chmod 0555
    bin.write_exec_script libexec/'betty'
  end

  test do
    system bin/'betty', 'speech on'
    system bin/'betty', 'what is your name'
    system bin/'betty', 'version'
    system bin/'betty', 'speech off'
  end
end
