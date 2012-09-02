require 'formula'

class RabbitmqSimpleamqpclient < Formula
  homepage 'https://github.com/alanxz/SimpleAmqpClient'
  url 'https://github.com/romainbossart/Hello-World/raw/master/SimpleAmqpClient-0.1.tar.bz2'
  md5 'da887f508476564dffa3b37bcf8e027f'

  depends_on 'cmake' => :build
  depends_on 'rabbitmq-c'

  fails_with :llvm do
    build 2336
    cause "Has to build against clang (for libc++ compatibility)"
  end
  fails_with :gcc do
    cause "Has to build against clang (for libc++ compatibility)"
  end

  def install
    args = std_cmake_args + %W{
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_USER_MAKE_RULES_OVERRIDE=ClangOverride.txt
      }

    system "cmake", *args
    system "make"
    system "make install"
  end
end
