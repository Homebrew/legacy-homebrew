class Apktool < Formula
  homepage "https://github.com/iBotPeaches/Apktool"
  url "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.0.0.jar", :using => :nounzip
  sha1 "0dd25996d8e23d8efcca0872dab6498af6f97c5e6cdef10005f5d82a7636f57d"

  def install
    libexec.install "apktool_#{version}.jar"
    bin.write_jar_script libexec/"apktool_#{version}.jar", "apktool"
  end
end
