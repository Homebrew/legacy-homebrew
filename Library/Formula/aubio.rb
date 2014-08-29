require 'formula'

class Aubio < Formula
  homepage 'http://aubio.org/'
  url 'http://aubio.org/pub/aubio-0.4.1.tar.bz2'
  sha1 '338ec9f633e82c371a370b9727d6f0b86b0ba376'

  bottle do
    cellar :any
    sha1 "959a1e4eb7bf72573f565af2ebe2c51eb7a6eef4" => :mavericks
    sha1 "d530d90d8e39ed5888bd492a3e3a888e21de2dc3" => :mountain_lion
    sha1 "5dc7cb95da354f22e32f8b754093e82d729cbe9f" => :lion
  end

  option :universal

  depends_on :macos => :lion

  depends_on :python => :optional
  depends_on 'pkg-config' => :build
  depends_on :libtool => :build

  if build.with? 'python'
    depends_on 'numpy' => :python
  end

  def install
    ENV.universal_binary if build.universal?

    # Needed due to issue with recent cland (-fno-fused-madd))
    ENV.refurbish_args

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"

    if build.with? 'python'
      cd 'python' do
        system "python", "./setup.py", "build"
        system "python", "./setup.py", "install", "--prefix", prefix
        bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
      end
    end
  end

  test do
    if build.with? 'python'
      system "#{bin}/aubiocut", "--verbose", "/System/Library/Sounds/Glass.aiff"
    end
    system "#{bin}/aubioonset", "--verbose", "/System/Library/Sounds/Glass.aiff"
  end
end
