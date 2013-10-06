require 'formula'

class Yaws < Formula
  homepage 'http://yaws.hyber.org'
  url 'https://github.com/klacke/yaws/archive/yaws-1.96.tar.gz'
  sha1 'c12fc517832299e95c3e02359edfc2271af9cc68'
  head 'https://github.com/klacke/yaws.git'

  option "without-yapp", "Omit yaws applications"
  option '32-bit'

  depends_on 'erlang'
  depends_on 'autoconf' => :build

  # the default config expects these folders to exist
  skip_clean 'var/log/yaws'
  skip_clean 'lib/yaws/examples/ebin'
  skip_clean 'lib/yaws/examples/include'

  # Patch is only pertinent for 1.96 tagged release and Erlang R16B01+
  # In newer versions of Erlang crypto:sha/1 is deprecated which fails
  # the compilation since it is treating warnings as errors.
  # This patch adds logic to use crypto:hash/2 for newer versions of
  # Erlang (R16B01+). --HEAD installs already have this fix in place thus
  # why it isn't included for --HEAD installs
  def patches
    unless build.head?
      { :p1 => [ 'https://github.com/klacke/yaws/compare/yaws-1.96...98db40b3d301254a86820a837848660cb9e1b2f0.diff' ] }
    end
  end
  def install
    if build.build_32_bit?
      %w{ CFLAGS LDFLAGS }.each do |compiler_flag|
        ENV.remove compiler_flag, "-arch #{Hardware::CPU.arch_64_bit}"
        ENV.append compiler_flag, "-arch #{Hardware::CPU.arch_32_bit}"
      end
    end

    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make install"

    unless build.include? 'without-yapp'
      cd 'applications/yapp' do
        system "make"
        system "make install"
      end
    end

    # the default config expects these folders to exist
    (lib/'yaws/examples/ebin').mkpath
    (lib/'yaws/examples/include').mkpath

    (var/'log/yaws').mkpath
    (var/'yaws/www').mkpath
  end

  def test
    system bin/'yaws', '--version'
  end

end
