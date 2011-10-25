require 'formula'

class Sfml < Formula
  url 'https://github.com/LaurentGomila/SFML.git',
      {:using => :git, :tag => '01254d41228d1fa6a186ca94c387da4984a0576c'}
  homepage 'http://www.sfml-dev.org/'
  version '2.0-01254d4122'
  md5 '4a0ebdde3cdfa4633cd001b375fc437b'

  head 'https://github.com/LaurentGomila/SFML.git',
       {:using => :git, :branch => 'master'}

  depends_on 'cmake'

  def install
    system "cmake . #{std_cmake_parameters} -DCMAKE_INSTALL_FRAMEWORK_PREFIX=#{prefix}/Frameworks/"
    system "make install"
  end
end
